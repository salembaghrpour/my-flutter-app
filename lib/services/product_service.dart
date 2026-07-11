// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;

import '../models/product.dart';
import '../constants/api_constants.dart';
import '../core/local/db/app_database.dart';
import 'connectivity_service.dart';

class ProductService {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<Product>> fetchProducts() async {
    final connectivity = Get.find<ConnectivityService>();

    // ۱. اگر آنلاین بودیم، از سرور دریافت کن و دیتابیس را آپدیت کن
    if (connectivity.isConnected.value) {
      try {
        final url = Uri.parse(ApiConstants.products); 
        final response = await http.get(url).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
          List<Product> products = data.map((json) => Product.fromJson(json)).toList();

          await _syncProductsToLocalDb(products);
          
          return products;
        } else {
          print('خطا در دریافت از سرور. کد وضعیت: ${response.statusCode}');
        }
      } catch (e) {
        print('خطای دریافت محصولات از سرور (احتمالا سرور خاموش است): $e.');
        print('سوئیچ به خواندن از دیتابیس آفلاین...');
      }
    } else {
      print('دستگاه آفلاین است. سوئیچ به خواندن از دیتابیس آفلاین...');
    }

    // ۲. دریافت از سرور خطا داد یا آفلاین بودیم، از دیتابیس Drift بخوان
    try {
      final localProducts = await _db.select(_db.products).get();
      if (localProducts.isEmpty) {
         print('هشدار: دیتابیس محلی خالی است! آیا قبلاً در حالت روشن بودن سرور، کالاها لود شده بودند؟');
         return []; // جلوگیری از کرش کردن با برگرداندن لیست خالی
      }
      
      print('✅ تعداد ${localProducts.length} محصول با موفقیت از دیتابیس آفلاین خوانده شد.');
      return localProducts.map((local) => Product.fromLocal(local)).toList();
    } catch (e) {
      print('❌ خطا در خواندن دیتابیس محلی محصولات: $e');
      // به جای throw Exception که باعث صفحه سفید می‌شود، لیست خالی برمی‌گردانیم
      return [];
    }
  }

  Future<void> _syncProductsToLocalDb(List<Product> products) async {
    try {
      for (var prod in products) {
        final companion = ProductsCompanion(
          id: drift.Value(prod.id),
          name: drift.Value(prod.name),
          code: drift.Value(prod.code ?? ''),
          barcode: drift.Value(prod.barcode ?? ''),
          sellingPrice: drift.Value(prod.sellingPrice),
          description: drift.Value(prod.description ?? ''),
          imagePath: drift.Value(prod.imagePath ?? ''),
          isActive: drift.Value(prod.isActive ?? true),
        );
        await _db.into(_db.products).insertOnConflictUpdate(companion);
      }
      print('✅ ${products.length} محصول با موفقیت در دیتابیس محلی ذخیره (Cache) شدند.');
    } catch (e) {
      print('❌ خطا در ذخیره محصولات در دیتابیس Drift رخ داد: $e');
    }
  }
}
