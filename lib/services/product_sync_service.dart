// lib/services/product_sync_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' as drift;

import '../constants/api_constants.dart';
import '../core/local/db/app_database.dart';

class ProductSyncService {
  final AppDatabase _db = AppDatabase.instance;

  // این متد کالاها را از سرور گرفته و در دیتابیس لوکال ذخیره/آپدیت می‌کند
  Future<void> fetchAndCacheProducts() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/products/');
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        
        // استفاده از Batch برای ذخیره سریع تمام کالاها به صورت یکجا
        await _db.batch((batch) {
          final productsToInsert = data.map((jsonItem) {
            return ProductsCompanion.insert(
              id: jsonItem['id'],
              name: jsonItem['name'] ?? 'بدون نام',
              code: drift.Value(jsonItem['code']?.toString()),
              barcode: drift.Value(jsonItem['barcode']?.toString()),
              sellingPrice: (jsonItem['selling_price'] ?? jsonItem['price'] ?? 0).toDouble(),
              description: drift.Value(jsonItem['description']),
              imagePath: drift.Value(jsonItem['image_path']),
              isActive: drift.Value(jsonItem['is_active'] ?? true),
            );
          }).toList();
          
          // insertAllOnConflictUpdate: اگر کالا وجود داشت آپدیت میکنه، اگر نبود اضافه میکنه
          batch.insertAllOnConflictUpdate(_db.products, productsToInsert);
        });
        
        print('✅ Products synced to local database successfully.');
      }
    } catch (e) {
      print('❌ Error syncing products to local DB: $e');
    }
  }

  // متد کمکی برای خواندن کالاها از دیتابیس در حالت آفلاین
  Future<List<LocalProduct>> getOfflineProducts() async {
    return await _db.select(_db.products).get();
  }
}
