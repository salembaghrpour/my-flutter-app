// lib/services/currency_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;

import '../models/catalog/currency_config.dart';
import '../constants/api_constants.dart';
import '../core/local/db/app_database.dart';
import 'connectivity_service.dart';

class CurrencyService {
  final AppDatabase _db = AppDatabase.instance;
  static const _catalogSyncedKey = 'products_catalog_synced_at';

  Future<CurrencyConfig?> fetchCurrency() async {
    final cachedAt = await _readCatalogSyncedAt();
    CurrencyConfig? remote;

    if (_isOnline) {
      try {
        remote = await _fetchCurrencyFromApi();
        if (remote != null && remote.hasBaseCurrency) {
          final normalized = remote.id > 0 ? remote : _withDefaultId(remote);
          final remoteAt = normalized.productsCatalogSyncedAt?.trim();
          final effectiveAt =
              (remoteAt != null && remoteAt.isNotEmpty) ? remoteAt : cachedAt;
          final merged = _withCatalogTime(normalized, effectiveAt);
          await _saveCurrencyToLocal(merged);
          if (effectiveAt != null && effectiveAt.trim().isNotEmpty) {
            await _saveCatalogSyncedAt(effectiveAt);
          }
          return merged;
        }
      } catch (_) {}
    }

    final local = await _getCurrencyFromLocal();
    if (local == null) return null;
    return _withCatalogTime(
      local,
      local.productsCatalogSyncedAt ?? cachedAt,
    );
  }

  bool get _isOnline {
    try {
      if (!Get.isRegistered<ConnectivityService>()) return true;
      return Get.find<ConnectivityService>().isConnected.value;
    } catch (_) {
      return true;
    }
  }

  Future<CurrencyConfig?> _fetchCurrencyFromApi() async {
    final url = Uri.parse(ApiConstants.currency);
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) return null;

    final decoded = json.decode(utf8.decode(response.bodyBytes));
    final map = _asCurrencyMap(decoded);
    if (map == null) return null;

    final config = CurrencyConfig.fromJson(map);
    return config.hasBaseCurrency ? config : null;
  }

  CurrencyConfig _withDefaultId(CurrencyConfig config) {
    return _withCatalogTime(config, config.productsCatalogSyncedAt, id: 1);
  }

  CurrencyConfig _withCatalogTime(
    CurrencyConfig config,
    String? syncedAt, {
    int? id,
  }) {
    return CurrencyConfig(
      id: id ?? config.id,
      accountingId: config.accountingId,
      baseCurrencyName: config.baseCurrencyName,
      baseCurrencySymbol: config.baseCurrencySymbol,
      varCurrencyName: config.varCurrencyName,
      varCurrencySymbol: config.varCurrencySymbol,
      exchangeRate: config.exchangeRate,
      isActive: config.isActive,
      lastUpdated: config.lastUpdated,
      syncedAt: config.syncedAt,
      productsCatalogSyncedAt: syncedAt,
    );
  }

  Map<String, dynamic>? _asCurrencyMap(dynamic decoded) {
    if (decoded is Map) {
      final map = Map<String, dynamic>.from(decoded);
      if (_looksLikeCurrency(map)) return map;

      for (final key in [
        'data',
        'item',
        'currency',
        'result',
        'results',
        'items',
        'config',
        'payload',
      ]) {
        final nested = map[key];
        final extracted = _asCurrencyMap(nested);
        if (extracted != null) return extracted;
      }
    }

    if (decoded is List) {
      for (final item in decoded) {
        final extracted = _asCurrencyMap(item);
        if (extracted != null) return extracted;
      }
    }

    return null;
  }

  bool _looksLikeCurrency(Map<String, dynamic> map) {
    return map['base_currency_name'] != null ||
        map['baseCurrencyName'] != null ||
        map['base_currency_symbol'] != null ||
        map['baseCurrencySymbol'] != null;
  }

  Future<void> _saveCurrencyToLocal(CurrencyConfig config) async {
    await _db.delete(_db.currenciesConfig).go();
    await _db.into(_db.currenciesConfig).insertOnConflictUpdate(
          CurrenciesConfigCompanion(
            id: drift.Value(config.id),
            accountingId: drift.Value(config.accountingId),
            baseCurrencyName: drift.Value(config.baseCurrencyName),
            baseCurrencySymbol: drift.Value(config.baseCurrencySymbol),
            varCurrencyName: drift.Value(config.varCurrencyName),
            varCurrencySymbol: drift.Value(config.varCurrencySymbol),
            exchangeRate: drift.Value(config.exchangeRate),
            isActive: drift.Value(config.isActive),
            lastUpdated: drift.Value(config.lastUpdated),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
  }

  Future<CurrencyConfig?> _getCurrencyFromLocal() async {
    try {
      final rows = await _db.select(_db.currenciesConfig).get();
      if (rows.isEmpty) return null;
      final row = rows.first;
      return CurrencyConfig(
        id: row.id,
        accountingId: row.accountingId,
        baseCurrencyName: row.baseCurrencyName,
        baseCurrencySymbol: row.baseCurrencySymbol,
        varCurrencyName: row.varCurrencyName,
        varCurrencySymbol: row.varCurrencySymbol,
        exchangeRate: row.exchangeRate,
        isActive: row.isActive,
        lastUpdated: row.lastUpdated,
        syncedAt: row.syncedAt,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _ensureSettingsTable() async {
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS local_app_settings (
        setting_key TEXT PRIMARY KEY,
        setting_value TEXT
      )
    ''');
  }

  Future<void> _saveCatalogSyncedAt(String value) async {
    try {
      await _ensureSettingsTable();
      await _db.customStatement(
        '''
        INSERT INTO local_app_settings (setting_key, setting_value)
        VALUES (?, ?)
        ON CONFLICT(setting_key) DO UPDATE SET
          setting_value = excluded.setting_value
        ''',
        [_catalogSyncedKey, value],
      );
    } catch (_) {}
  }

  Future<String?> _readCatalogSyncedAt() async {
    try {
      await _ensureSettingsTable();
      final rows = await _db.customSelect(
        'SELECT setting_value FROM local_app_settings WHERE setting_key = ?',
        variables: [drift.Variable.withString(_catalogSyncedKey)],
      ).get();
      if (rows.isEmpty) return null;
      final value = rows.first.data['setting_value']?.toString().trim();
      if (value == null || value.isEmpty || value.toLowerCase() == 'null') {
        return null;
      }
      return value;
    } catch (_) {
      return null;
    }
  }
}
