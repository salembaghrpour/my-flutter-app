// lib/controllers/order_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;

import 'cart_controller.dart';
import '../constants/api_constants.dart';
import '../services/connectivity_service.dart';
import '../services/order_sync_service.dart';
import '../core/local/db/app_database.dart';
import '../models/cart/cart_line.dart'; // اضافه شده

class OrderController extends GetxController {
  var isLoading = false.obs;

  final CartController cartController = Get.find<CartController>();
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  final AppDatabase _localDb = AppDatabase.instance;

  List<Map<String, dynamic>> _cartPayload() {
    return cartController.toOrderItems(); // حالا از CartLine برمی‌گردد
  }

  String _serverError(http.Response response) {
    try {
      final body = json.decode(utf8.decode(response.bodyBytes));
      if (body is Map && body['detail'] != null) {
        return body['detail'].toString();
      }
    } catch (_) {}
    return 'مشکل در ثبت سفارش در سرور (خطای ${response.statusCode})';
  }

  Future<bool> submitOrder(String paymentMethod) async {
    if (cartController.cartItems.isEmpty) {
      Get.snackbar('خطا', 'سبد خرید شما خالی است');
      return false;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? realProfileId = prefs.getString('profileId');

      if (realProfileId == null || realProfileId.isEmpty) {
        Get.snackbar('خطا', 'لطفا ابتدا وارد حساب کاربری خود شوید.');
        return false;
      }

      final items = _cartPayload();

      if (!_connectivityService.isConnected.value) {
        return await _saveOrderLocally(realProfileId, paymentMethod, items);
      }

      final requestBody = {
        'profile_id': realProfileId,
        'user_type': 'customer',
        'description': 'ثبت از طریق اپلیکیشن موبایل',
        'payment_method': paymentMethod,
        'items': items,
      };

      final response = await http
          .post(
            Uri.parse(ApiConstants.orders),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        cartController.clearCart();
        String msg = 'سفارش شما با موفقیت در سرور ثبت شد';
        try {
          final data = json.decode(utf8.decode(response.bodyBytes));
          final tracking = data['tracking_number'];
          if (tracking != null) {
            msg = 'سفارش ثبت شد. شماره پیگیری: $tracking';
          }
        } catch (_) {}
        Get.snackbar('موفق', msg);
        _triggerSyncIfAvailable();
        return true;
      }

      Get.snackbar('خطا', _serverError(response));
      return false;
    } catch (e) {
      print('Network/Server Error: $e -> Fallback to Offline Mode');
      final prefs = await SharedPreferences.getInstance();
      final realProfileId = prefs.getString('profileId');
      if (realProfileId != null) {
        return await _saveOrderLocally(
          realProfileId,
          paymentMethod,
          _cartPayload(),
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _triggerSyncIfAvailable() {
    if (Get.isRegistered<OrderSyncService>()) {
      Get.find<OrderSyncService>().syncOfflineOrders();
    }
  }

  Future<bool> _saveOrderLocally(
    String profileId,
    String paymentMethod,
    List<Map<String, dynamic>> items,
  ) async {
    try {
      final orderCompanion = OfflineOrdersCompanion(
        profileId: drift.Value(profileId),
        totalPrice: drift.Value(cartController.totalPrice),
        paymentMethod: drift.Value(paymentMethod),
        isSynced: const drift.Value(false),
      );

      final itemsCompanion = items
          .map((item) => OfflineOrderItemsCompanion(
                productId: drift.Value(item['product_id'] as int),
                quantity: drift.Value((item['quantity'] as num).round()),
                unitPrice: drift.Value((item['unit_price'] as num).toDouble()),
              ))
          .toList();

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
