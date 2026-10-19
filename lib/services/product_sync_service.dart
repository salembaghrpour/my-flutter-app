// lib/services/product_sync_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' as drift;

import '../constants/api_constants.dart';
import '../core/local/db/app_database.dart';
import '../models/product.dart';

List<dynamic> _asProductList(dynamic decoded) {
  if (decoded is List) return decoded;
  if (decoded is Map) {
    final raw = decoded['data'] ??
        decoded['items'] ??
        decoded['products'] ??
        decoded['results'];
    if (raw is List) return raw;
  }
  return const [];
}

Map<String, dynamic> _normalizeProductMap(Map<String, dynamic> raw) {
  final map = Map<String, dynamic>.from(raw);
  final extra = map['extra_attributes'] ?? map['extraAttributes'];
  if (extra is String && extra.trim().isNotEmpty) {
    try {
      map['extra_attributes'] = json.decode(extra);
    } catch (_) {}
  }
  return map;
}

class ProductSyncService {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> fetchAndCacheProducts() async {
    try {
      final url = Uri.parse(ApiConstants.products);
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return;

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      final products = _asProductList(decoded)
          .whereType<Map>()
          .map(
            (item) => Product.fromJson(
              _normalizeProductMap(Map<String, dynamic>.from(item)),
            ),
          )
          .toList();

      await _db.batch((batch) {
        final productsToInsert = products.map((prod) {
          return ProductsCompanion(
            id: drift.Value(prod.id),
            name: drift.Value(prod.name),
            code: drift.Value(prod.code ?? ''),
            barcode: drift.Value(prod.barcode ?? ''),
            sellingPrice: drift.Value(prod.sellingPrice),
            description: drift.Value(prod.description ?? ''),
            imagePath: drift.Value(prod.imagePath ?? ''),
            isActive: drift.Value(prod.isActive),
            baseUnitId: drift.Value(prod.baseUnitId),
            baseUnitName: drift.Value(prod.baseUnitName),
            hasMultiUnits: drift.Value(prod.hasMultiUnits),
            hasBatches: drift.Value(prod.hasBatches),
          );
        }).toList();

        batch.insertAllOnConflictUpdate(_db.products, productsToInsert);
      });

      print('✅ Products synced to local database successfully.');
    } catch (e) {
      print('❌ Error syncing products to local DB: $e');
    }
  }

  Future<List<LocalProduct>> getOfflineProducts() async {
    return await _db.select(_db.products).get();
  }
}
