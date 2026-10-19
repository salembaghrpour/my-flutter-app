import 'package:get/get.dart';

import '../../core/local/db/app_database.dart';
import '../../models/ledger/ledger_entry.dart';
import '../../services/connectivity_service.dart';
import '../../services/ledger/ledger_service.dart';
import '../../services/storage_service.dart';
import '../auth_controller.dart';

class LedgerController extends GetxController {
  final entries = <LedgerEntry>[].obs;
  final isLoading = true.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;
  final syncWarning = ''.obs;
  final isOffline = false.obs;
  final isFromCache = false.obs;
  final lastSyncedAt = Rxn<DateTime>();

  final AppDatabase _db = AppDatabase.instance;

  Worker? _connectivityWorker;
  Future<void>? _inFlight;

  @override
  void onInit() {
    super.onInit();
    _bindConnectivity();
    fetchHistory();
  }

  @override
  void onClose() {
    _connectivityWorker?.dispose();
    super.onClose();
  }

  void _bindConnectivity() {
    if (!Get.isRegistered<ConnectivityService>()) return;

    final connectivity = Get.find<ConnectivityService>();
    isOffline.value = !connectivity.isConnected.value;

    _connectivityWorker = ever<bool>(connectivity.isConnected, (connected) {
      isOffline.value = !connected;
      if (connected) {
        fetchHistory(silent: true);
      }
    });
  }

  bool _isOnline() {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    return Get.find<ConnectivityService>().isConnected.value;
  }

  bool _looksLikeJwt(String? value) {
    if (value == null) return false;
    var raw = value.trim();
    if (raw.toLowerCase().startsWith('bearer ')) {
      raw = raw.substring(7).trim();
    }
    return raw.split('.').length == 3;
  }

  String? _tokenFromAuthController() {
    if (!Get.isRegistered<AuthController>()) return null;

    final authController = Get.find<AuthController>();
    final dynamic raw = authController.token;
    if (raw == null) return null;
    if (raw is String) return raw;

    try {
      final value = raw.value;
      if (value is String) return value;
    } catch (_) {}

    return null;
  }

  String? _resolveAccessToken() {
    final candidates = <String?>[];

    if (Get.isRegistered<StorageService>()) {
      candidates.add(Get.find<StorageService>().token);
    }
    candidates.add(_tokenFromAuthController());

    String? fallback;
    for (final candidate in candidates) {
      if (candidate == null) continue;
      final value = candidate.trim();
      if (value.isEmpty) continue;
      fallback ??= value;
      if (_looksLikeJwt(value)) {
        return value.toLowerCase().startsWith('bearer ')
            ? value.substring(7).trim()
            : value;
      }
    }
    return fallback;
  }

  Future<void> _loadFromLocal() async {
    final rows = await _db.getCachedLedgerEntries();
    if (rows.isEmpty) return;

    entries.assignAll(rows.map(LedgerEntry.fromLocal).toList());
    isFromCache.value = true;
    lastSyncedAt.value = await _db.getLedgerLastSyncedAt();
  }

  Future<void> _saveToLocal(List<LedgerEntry> data) async {
    final now = DateTime.now();
    final rows = <LedgerEntriesCompanion>[];
    for (var i = 0; i < data.length; i++) {
      rows.add(data[i].toCompanion(sortIndex: i, syncedAt: now));
    }
    await _db.replaceLedgerEntries(rows);
    lastSyncedAt.value = now;
  }

  String _mapError(Object error, {required bool withCache}) {
    final text = error.toString();
    if (text.contains('401')) {
      return withCache
          ? 'نشست شما منقضی شده است. آخرین نسخه ذخیره‌شده نمایش داده می‌شود.'
          : 'دسترسی نامعتبر است. لطفاً دوباره وارد شوید.';
    }
    return withCache
        ? 'به‌روزرسانی از سرور ممکن نشد. آخرین نسخه ذخیره‌شده نمایش داده می‌شود.'
        : 'مشکلی در دریافت اطلاعات پیش آمد.';
  }

  Future<void> fetchHistory({bool silent = false}) {
    if (_inFlight != null) return _inFlight!;
    _inFlight = _fetchHistoryInternal(silent: silent).whenComplete(() {
      _inFlight = null;
    });
    return _inFlight!;
  }

  Future<void> _fetchHistoryInternal({required bool silent}) async {
    try {
      errorMessage.value = '';
      syncWarning.value = '';

      if (entries.isEmpty) {
        await _loadFromLocal();
      }

      final hasCache = entries.isNotEmpty;
      final online = _isOnline();
      isOffline.value = !online;

      if (!silent && !hasCache) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
        isRefreshing.value = true;
      }

      final token = _resolveAccessToken();
      if (token == null || token.isEmpty) {
        if (hasCache) {
          isFromCache.value = true;
          syncWarning.value =
              'برای به‌روزرسانی صورتحساب دوباره وارد حساب کاربری شوید.';
        } else {
          errorMessage.value = 'شما وارد حساب کاربری نشده‌اید.';
        }
        return;
      }

      if (!_looksLikeJwt(token)) {
        print(
          'LEDGER TOKEN INVALID: raw="$token" len=${token.length}, '
          'segments=${token.split('.').length}',
        );
        if (hasCache) {
          isFromCache.value = true;
          syncWarning.value =
              'توکن ورود نامعتبر است. آخرین نسخه ذخیره‌شده نمایش داده می‌شود.';
        } else {
          errorMessage.value = 'توکن ورود نامعتبر است. لطفاً دوباره وارد شوید.';
        }
        return;
      }

      if (!online) {
        if (hasCache) {
          isFromCache.value = true;
        } else {
          errorMessage.value =
              'در حال حاضر آفلاین هستید و صورتحساب ذخیره‌شده‌ای وجود ندارد.';
        }
        return;
      }

      try {
        final fetchedEntries = await LedgerService.fetchLedgerHistory(token);
        await _saveToLocal(fetchedEntries);
        entries.assignAll(fetchedEntries);
        isFromCache.value = false;
        errorMessage.value = '';
        syncWarning.value = '';
      } catch (e) {
        print('Ledger fetch error: $e');
        if (entries.isEmpty) {
          await _loadFromLocal();
        }
        if (entries.isNotEmpty) {
          isFromCache.value = true;
          syncWarning.value = _mapError(e, withCache: true);
        } else {
          errorMessage.value = _mapError(e, withCache: false);
        }
      }
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }
}
