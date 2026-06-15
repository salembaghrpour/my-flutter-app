// lib/controllers/order_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // اضافه کردن SharedPreferences
import 'cart_controller.dart';
import 'package:flutter/foundation.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  final CartController cartController = Get.find<CartController>();

  // دقت کنید: profileId را از ورودی تابع حذف کردیم تا فقط متد پرداخت را بگیرد
  Future<bool> submitOrder(String paymentMethod) async {
    if (cartController.cartItems.isEmpty) {
      Get.snackbar('خطا', 'سبد خرید شما خالی است');
      return false;
    }

    isLoading.value = true;
    try {
      // --- خواندن شناسه واقعی کاربر از حافظه ---
      final prefs = await SharedPreferences.getInstance();
      // اصلاح نام کلیدها بر اساس auth_controller.dart
      String? realProfileId = prefs.getString('profileId') ?? prefs.getString('userId'); 
      
      if (realProfileId == null || realProfileId.isEmpty) {
        Get.snackbar('خطا', 'لطفا ابتدا وارد حساب کاربری خود شوید.');
        return false;
      }

      // آماده‌سازی اقلام سفارش بر اساس ساختار بک‌اند
      List<Map<String, dynamic>> items = cartController.cartItems.map((item) {
        return {
          "product_id": item['id'],
          "quantity": item['quantity'],
          "unit_price": double.tryParse(item['selling_price'].toString()) ?? 0.0,
        };
      }).toList();

      // ساخت بدنه درخواست
      Map<String, dynamic> requestBody = {
        "profile_id": realProfileId, // استفاده از شناسه واقعی
        "total_price": cartController.totalPrice,
        "description": "ثبت از طریق اپلیکیشن موبایل",
        "payment_method": paymentMethod,
        "items": items
      };

      // تعیین آدرس سرور (وب یا موبایل)
      String baseUrl = kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000';
      final url = Uri.parse('$baseUrl/api/orders/'); 
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        cartController.clearCart();
        Get.snackbar('موفق', 'سفارش شما با موفقیت ثبت شد');
        return true;
      } else {
        Get.snackbar('خطا', 'مشکل در ثبت سفارش. دوباره تلاش کنید.');
        return false;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطای ارتباط با سرور: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
