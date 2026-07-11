// lib/controllers/order_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;

import 'cart_controller.dart';
import '../constants/api_constants.dart';
import '../services/connectivity_service.dart';
import '../services/order_sync_service.dart'; // سرویس جدید اضافه شد
import '../core/local/db/app_database.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  
  final CartController cartController = Get.find<CartController>();
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  final AppDatabase _localDb = AppDatabase.instance;

  Future<bool> submitOrder(String paymentMethod) async {
    if (cartController.cartItems.isEmpty) {
      Get.snackbar('خطا', 'سبد خرید شما خالی است');
      return false;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? realProfileId = prefs.getString('profileId') ?? prefs.getString('userId'); 
      
      if (realProfileId == null || realProfileId.isEmpty) {
        Get.snackbar('خطا', 'لطفا ابتدا وارد حساب کاربری خود شوید.');
        return false;
      }

      // آماده‌سازی اقلام سفارش برای جلوگیری از تکرار کد
      List<Map<String, dynamic>> items = cartController.cartItems.map((item) {
        return {
          "product_id": item['id'],
          "quantity": item['quantity'],
          "unit_price": double.tryParse(item['selling_price'].toString()) ?? 0.0,
        };
      }).toList();

      // ۱. اگر آفلاین هستیم، مستقیما در دیتابیس ذخیره کن و خارج شو
      if (!_connectivityService.isConnected.value) {
        return await _saveOrderLocally(realProfileId, paymentMethod, items);
      }

      // ۲. در صورت آنلاین بودن، تلاش برای ارسال به سرور
      Map<String, dynamic> requestBody = {
        "profile_id": realProfileId,
        "user_type": "customer",
        "total_price": cartController.totalPrice,
        "description": "ثبت از طریق اپلیکیشن موبایل",
        "payment_method": paymentMethod,
        "items": items
      };

      final url = Uri.parse('${ApiConstants.baseUrl}/api/orders/'); 
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        cartController.clearCart();
        Get.snackbar('موفق', 'سفارش شما با موفقیت در سرور ثبت شد');
        
        // در صورت موفقیت، اگر سفارش آفلاین قبلی وجود دارد آن را هم بفرست
        _triggerSyncIfAvailable();
        return true;
      } else {
        Get.snackbar('خطا', 'مشکل در ثبت سفارش در سرور (خطای ${response.statusCode})');
        return false; 
      }

    } catch (e) {
      // ۳. اگر به هر دلیلی درخواست Fail شد -> ذخیره آفلاین
      print("Network/Server Error: $e -> Fallback to Offline Mode");
      
      final prefs = await SharedPreferences.getInstance();
      String? realProfileId = prefs.getString('profileId') ?? prefs.getString('userId');
      
      if (realProfileId != null) {
        List<Map<String, dynamic>> items = cartController.cartItems.map((item) {
          return {
            "product_id": item['id'],
            "quantity": item['quantity'],
            "unit_price": double.tryParse(item['selling_price'].toString()) ?? 0.0,
          };
        }).toList();
        
        return await _saveOrderLocally(realProfileId, paymentMethod, items);
      }
      return false;
      
    } finally {
      isLoading.value = false;
    }
  }

  // فرخوانی سرویس همگام‌سازی در صورت موجود بودن در حافظه برنامه
  void _triggerSyncIfAvailable() {
    if (Get.isRegistered<OrderSyncService>()) {
      Get.find<OrderSyncService>().syncOfflineOrders();
    }
  }

  // ---- متد خصوصی برای ذخیره سفارش در دیتابیس (Drift) ----
  Future<bool> _saveOrderLocally(String profileId, String paymentMethod, List<Map<String, dynamic>> items) async {
    try {
      final orderCompanion = OfflineOrdersCompanion(
        profileId: drift.Value(profileId),
        totalPrice: drift.Value(cartController.totalPrice),
        paymentMethod: drift.Value(paymentMethod),
        isSynced: const drift.Value(false), 
      );

      final itemsCompanion = items.map((item) => OfflineOrderItemsCompanion(
        productId: drift.Value(item['product_id'] as int),
        quantity: drift.Value(item['quantity'] as int),
        unitPrice: drift.Value(item['unit_price'] as double),
      )).toList();

      await _localDb.saveOfflineOrder(orderCompanion, itemsCompanion);
      
      cartController.clearCart();
      Get.snackbar(
        'ثبت آفلاین', 
        'شما آفلاین هستید. سفارش در دستگاه ذخیره شد و پس از اتصال به اینترنت خودکار ارسال می‌شود.',
        duration: const Duration(seconds: 5),
      );
      return true;
    } catch (e) {
      Get.snackbar('خطای پایگاه داده', 'مشکل در ذخیره آفلاین سفارش: $e');
      return false;
    }
  }
}
