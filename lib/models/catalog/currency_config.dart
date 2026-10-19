// lib/models/catalog/currency_config.dart
class CurrencyConfig {
  final int id;
  final int? accountingId;
  final String baseCurrencyName;
  final String baseCurrencySymbol;
  final String? varCurrencyName;
  final String? varCurrencySymbol;
  final double? exchangeRate;
  final bool isActive;
  final DateTime? lastUpdated;
  final DateTime? syncedAt;
  final String? productsCatalogSyncedAt;

  const CurrencyConfig({
    required this.id,
    this.accountingId,
    required this.baseCurrencyName,
    required this.baseCurrencySymbol,
    this.varCurrencyName,
    this.varCurrencySymbol,
    this.exchangeRate,
    this.isActive = true,
    this.lastUpdated,
    this.syncedAt,
    this.productsCatalogSyncedAt,
  });

  bool get hasBaseCurrency =>
      baseCurrencyName.trim().isNotEmpty || baseCurrencySymbol.trim().isNotEmpty;

  String get displaySymbol {
    final symbol = baseCurrencySymbol.trim();
    if (symbol.isNotEmpty) return symbol;
    return baseCurrencyName.trim();
  }

  String get headerText {
    final name = baseCurrencyName.trim();
    final symbol = baseCurrencySymbol.trim();
    if (name.isEmpty && symbol.isEmpty) return '';
    if (name.isNotEmpty && symbol.isNotEmpty && name != symbol) {
      return 'ارز پایه: $name ($symbol)';
    }
    return 'ارز پایه: ${name.isNotEmpty ? name : symbol}';
  }

  static String cleanString(dynamic value) {
    if (value == null) return '';
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return '';
    return text;
  }

  static String? cleanNullableString(dynamic value) {
    final text = cleanString(value);
    return text.isEmpty ? null : text;
  }

  static int? parseInt(dynamic value) {
    if (value == null || value == '' || value == 'null') return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static double? parseDouble(dynamic value) {
    if (value == null || value == '' || value == 'null') return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim().replaceAll(',', ''));
  }

  static bool parseBool(dynamic value, {bool fallback = true}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final text = value.toLowerCase().trim();
      if (text == 'true' || text == '1' || text == 'yes') return true;
      if (text == 'false' || text == '0' || text == 'no') return false;
    }
    return fallback;
  }

  static DateTime? parseDate(dynamic value) {
    if (value == null || value == '' || value == 'null') return null;
    if (value is DateTime) return value;
    final text = value.toString().trim().replaceFirst(' ', 'T');
    return DateTime.tryParse(text);
  }

  factory CurrencyConfig.fromJson(Map<String, dynamic> json) {
    return CurrencyConfig(
      id: parseInt(json['id']) ?? 0,
      accountingId: parseInt(json['accounting_id'] ?? json['accountingId']),
      baseCurrencyName: cleanString(
        json['base_currency_name'] ?? json['baseCurrencyName'],
      ),
      baseCurrencySymbol: cleanString(
        json['base_currency_symbol'] ?? json['baseCurrencySymbol'],
      ),
      varCurrencyName: cleanNullableString(
        json['var_currency_name'] ?? json['varCurrencyName'],
      ),
      varCurrencySymbol: cleanNullableString(
        json['var_currency_symbol'] ?? json['varCurrencySymbol'],
      ),
      exchangeRate: parseDouble(json['exchange_rate'] ?? json['exchangeRate']),
      isActive: parseBool(json['is_active'] ?? json['isActive']),
      lastUpdated: parseDate(json['last_updated'] ?? json['lastUpdated']),
      syncedAt: parseDate(json['synced_at'] ?? json['syncedAt']),
      productsCatalogSyncedAt: cleanNullableString(
        json['products_catalog_synced_at'] ?? json['productsCatalogSyncedAt'],
      ),
    );
  }
}
