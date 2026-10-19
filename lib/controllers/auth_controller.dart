import 'dart:convert';

import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../core/local/db/app_database.dart';
import '../services/local_db/chat_local_repository.dart';
import 'chat/chat_controller.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var token = ''.obs;
  var profileId = ''.obs;
  var userName = ''.obs;

  bool get isLoggedIn => _looksLikeJwt(token.value);

  final AuthService _authService = AuthService();
  final StorageService _storageService = Get.find<StorageService>();

  bool _looksLikeJwt(String? value) {
    if (value == null) return false;
    var raw = value.trim();
    if (raw.isEmpty || raw == 'null' || raw == 'undefined') return false;
    if (raw.toLowerCase().startsWith('bearer ')) {
      raw = raw.substring(7).trim();
    }
    return raw.split('.').length == 3;
  }

  String _cleanToken(String value) {
    var raw = value.trim();
    if (raw.toLowerCase().startsWith('bearer ')) {
      raw = raw.substring(7).trim();
    }
    return raw;
  }

  String _profileIdFromToken(String jwt) {
    try {
      final parts = _cleanToken(jwt).split('.');
      if (parts.length != 3) return '';

      var payload = parts[1];
      final remainder = payload.length % 4;
      if (remainder > 0) {
        payload += '=' * (4 - remainder);
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final data = jsonDecode(decoded);
      if (data is! Map) return '';

      for (final key in [
        'profile_id',
        'customer_id',
        'user_uuid',
        'driver_id',
        'employee_id',
      ]) {
        final value = data[key]?.toString().trim() ?? '';
        if (value.isNotEmpty && value != 'null') return value;
      }
    } catch (e) {
      print('PROFILE ID DECODE ERROR: $e');
    }
    return '';
  }

  String _resolveProfileId(String serviceProfileId, String jwt) {
    final fromService = serviceProfileId.trim();
    if (fromService.isNotEmpty && fromService != 'null') return fromService;
    return _profileIdFromToken(jwt);
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserDataFromStorage();
  }

  void _loadUserDataFromStorage() {
    final storedToken = _storageService.token ?? '';
    final storedName = _storageService.userName ?? '';

    if (_looksLikeJwt(storedToken)) {
      final resolvedId = _resolveProfileId(
        _storageService.profileId ?? '',
        storedToken,
      );

      token.value = _cleanToken(storedToken);
      profileId.value = resolvedId;
      userName.value = storedName;

      if (resolvedId.isNotEmpty &&
          (_storageService.profileId ?? '').trim() != resolvedId) {
        _storageService.saveAuthData(
          token: token.value,
          profileId: resolvedId,
          userName: storedName,
        );
      }
      return;
    }

    if (storedToken.isNotEmpty) {
      print(
        'STORED TOKEN INVALID: raw="$storedToken" '
        'len=${storedToken.length}',
      );
    }
    token.value = '';
    profileId.value = '';
    userName.value = storedName;
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('خطا', 'لطفاً نام کاربری و رمز عبور را وارد کنید.');
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.login(username, password);

      if (user != null) {
        final cleanToken = _cleanToken(user.token);
        final resolvedId = _resolveProfileId(user.profileId, cleanToken);

        print(
          'LOGIN TOKEN: $cleanToken, '
          'segments=${cleanToken.split('.').length}, '
          'profileId=$resolvedId',
        );

        if (!_looksLikeJwt(cleanToken)) {
          Get.snackbar(
            'خطای ورود',
            'سرور توکن معتبر برنگرداند. لطفاً دوباره تلاش کنید.',
          );
          return;
        }

        if (resolvedId.isEmpty) {
          Get.snackbar(
            'خطای ورود',
            'شناسه مشتری در پاسخ سرور پیدا نشد.',
          );
          return;
        }

        await _clearLocalDatabases();

        await _storageService.saveAuthData(
          token: cleanToken,
          profileId: resolvedId,
          userName: user.username,
        );

        token.value = cleanToken;
        profileId.value = resolvedId;
        userName.value = user.username;

        try {
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await _authService.updateFcmToken(resolvedId, fcmToken);
          }
        } catch (e) {
          print('Error getting/sending FCM token: $e');
        }

        Get.offAllNamed('/main');

        Get.snackbar(
          'ورود موفق',
          '${user.username} عزیز، خوش آمدید!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar('خطای ورود', 'نام کاربری یا رمز عبور اشتباه است.');
      }
    } catch (e) {
      Get.snackbar('خطا', 'مشکلی در ارتباط با سرور پیش آمد.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _clearLocalDatabases() async {
    try {
      await AppDatabase.instance.clearAllData();
      await ChatLocalRepository().clearAllMessages();
      print('Local databases cleared successfully.');
    } catch (e) {
      print('Error clearing local databases: $e');
    }
  }

  Future<void> logout() async {
    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().resetChat();
      Get.delete<ChatController>(force: true);
    }

    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      print('Error deleting FCM token: $e');
    }

    await _clearLocalDatabases();
    await _storageService.clearAuthData();

    token.value = '';
    profileId.value = '';
    userName.value = '';

    Get.offAllNamed('/login');
  }
}
