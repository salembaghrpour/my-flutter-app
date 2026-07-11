// lib/services/order_sync_service.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import '../core/local/db/app_database.dart';
import 'connectivity_service.dart';

class OrderSyncService extends GetxService {
  final AppDatabase _db = AppDatabase.instance;
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  bool _isSyncing = false;
  Timer? _syncTimer;

  @override
  void onInit() {
    super.onInit();
    
    // ۱. بررسی اولیه
    Future.delayed(const Duration(seconds: 3), () => syncOfflineOrders(fromTimer: false));

    // ۲. گوش دادن به وضعیت اینترنت
    ever(_connectivityService.isConnected, (bool isConnected) {
      if (isConnected) {
        print("🌐 تغییر وضعیت اینترنت تشخیص داده شد: آنلاین");
        syncOfflineOrders(fromTimer: false);
      } else {
        print("🌐 تغییر وضعیت اینترنت تشخیص داده شد: آفلاین");
      }
    });

    // ۳. تایمر برای چک کردن دوره‌ای (مخصوص مرورگر کروم که روشن شدن سرور را تشخیص نمی‌دهد)
    _syncTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      syncOfflineOrders(fromTimer: true);
    });
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    super.onClose();
  }

  Future<void> syncOfflineOrders({bool fromTimer = false}) async {
    if (_isSyncing) return;
    
    if (!_connectivityService.isConnected.value && !fromTimer) {
      print("⚠️ متوقف شد: دستگاه در حالت آفلاین قرار دارد.");
      return;
    }
    
    _isSyncing = true;

    try {
      final unsyncedOrders = await (_db.select(_db.offlineOrders)
        ..where((t) => t.isSynced.equals(false))).get();

      if (unsyncedOrders.isEmpty) {
        _isSyncing = false;
        return;
      }

      if (!fromTimer) print('🚀 در حال ارسال ${unsyncedOrders.length} سفارش آفلاین به سرور...');

      for (var order in unsyncedOrders) {
        final items = await (_db.select(_db.offlineOrderItems)
          ..where((t) => t.orderId.equals(order.id))).get();

        List<Map<String, dynamic>> orderItemsList = items.map((item) {
          return {
            "product_id": item.productId,
            "quantity": item.quantity,
            "unit_price": item.unitPrice,
          };
        }).toList();

        Map<String, dynamic> requestBody = {
          "profile_id": order.profileId,
          "user_type": "customer",
          "total_price": order.totalPrice,
          "description": "ثبت خودکار آفلاین از طریق اپلیکیشن",
          "payment_method": order.paymentMethod,
          "items": orderItemsList
        };

        final url = Uri.parse('${ApiConstants.baseUrl}/api/orders/');
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(requestBody),
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('✅ سفارش آفلاین ${order.id} با موفقیت در سرور ثبت شد.');
          await (_db.delete(_db.offlineOrders)..where((t) => t.id.equals(order.id))).go();
          await (_db.delete(_db.offlineOrderItems)..where((t) => t.orderId.equals(order.id))).go();
        } else {
          if (!fromTimer) print('❌ خطا در ثبت سفارش آفلاین ${order.id} (کد: ${response.statusCode})');
        }
      }
    } catch (e) {
      if (!fromTimer) print('❌ خطا در فرآیند همگام‌سازی (احتمالا سرور هنوز قطع است).');
    } finally {
      _isSyncing = false;
    }
  }
}
