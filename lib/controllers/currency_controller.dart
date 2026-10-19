// lib/controllers/currency_controller.dart
import 'package:get/get.dart';
import '../models/catalog/currency_config.dart';
import '../services/currency_service.dart';
import '../utils/jalali_date.dart';

class CurrencyController extends GetxController {
  final CurrencyService _service = CurrencyService();

  final Rxn<CurrencyConfig> config = Rxn<CurrencyConfig>();
  final RxBool loading = false.obs;

  String get baseName => config.value?.baseCurrencyName.trim() ?? '';
  String get baseSymbol => config.value?.baseCurrencySymbol.trim() ?? '';
  String get displaySymbol => config.value?.displaySymbol ?? '';
  String get headerText => config.value?.headerText ?? '';

  String get catalogUpdatedText {
    final raw = config.value?.productsCatalogSyncedAt?.trim() ?? '';
    if (raw.isEmpty) return '';
    final jalali = JalaliDate.formatRaw(raw);
    if (jalali.isEmpty) return '';
    return 'بروزرسانی کالا: $jalali';
  }

  /// واحد نمایشی از currencies_config؛ اگر هنوز لود نشده باشد ریال.
  String get currencyLabel {
    if (displaySymbol.isNotEmpty) return displaySymbol;
    if (baseName.isNotEmpty) return baseName;
    return 'ریال';
  }

  static CurrencyController get instance {
    if (Get.isRegistered<CurrencyController>()) {
      return Get.find<CurrencyController>();
    }
    return Get.put(CurrencyController(), permanent: true);
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      final fetched = await _service.fetchCurrency();
      if (fetched != null) {
        config.value = fetched;
      }
    } catch (_) {
      // config قبلی اگر وجود داشته باشد حفظ می‌شود
    } finally {
      loading.value = false;
    }
  }
}
