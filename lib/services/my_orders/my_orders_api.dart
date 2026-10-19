// D:\accounting_Arya\mobile_app\customer_app\lib\services\my_orders\my_orders_api.dart
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../models/my_orders/my_order_detail.dart';
import '../../models/my_orders/my_order_summary.dart';

class MyOrdersApi extends GetConnect {
  static const String serverUrl = 'http://127.0.0.1:8000';

  MyOrdersApi() {
    httpClient.baseUrl = serverUrl;
    httpClient.timeout = const Duration(seconds: 25);
    
    // افزودن Interceptor برای لاگ کردن درخواست‌ها (جهت دیباگ راحت‌تر)
    httpClient.addRequestModifier<dynamic>((request) {
      print('--> ${request.method} ${request.url}');
      print('    Headers: ${request.headers}');
      return request;
    });
  }

  /// آماده‌سازی هدرها و افزودن توکن
  Map<String, String> _headers() {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // فراخوانی متد برای دریافت توکن از AuthController
    final String? token = _readToken();
    
    print('--- DEBUG: Token being used for header: ${token ?? "NOT FOUND"}');

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// پیدا کردن توکن از AuthController که قبلاً هنگام لاگین مقداردهی شده است
  String? _readToken() {
    try {
      // بررسی می‌کنیم که آیا AuthController در GetX ثبت شده است یا خیر
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        final token = authController.token.value;
        
        if (token.isNotEmpty) {
          print('>>> Token successfully read from AuthController');
          return token;
        } else {
          print('!!! WARNING: AuthController found, but token is empty.');
        }
      } else {
        print('!!! CRITICAL: AuthController is not registered in GetX.');
      }
    } catch (e) {
      print('!!! Error reading token from AuthController: $e');
    }
    
    return null;
  }

  /// دریافت لیست سفارش‌ها
  Future<List<MyOrderSummary>> fetchOrders() async {
    final Response<dynamic> res = await get(
      '/api/customer/orders/',
      headers: _headers(),
    );

    if (res.hasError) {
       print('!!! API Error on fetchOrders: ${res.statusCode} - ${res.bodyString}');
       if (res.statusCode == 401) {
         throw 'خطای احراز هویت. لطفا مجددا وارد شوید.';
       }
       throw 'خطا در دریافت لیست سفارش‌ها (${res.statusCode})';
    }

    final dynamic data = res.body;
    final List<dynamic> list = data is List ? data : (data['results'] as List? ?? []);

    return list.map((dynamic e) => MyOrderSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// دریافت جزئیات یک سفارش خاص
  Future<MyOrderDetail> fetchOrderDetail(String orderId) async {
    final Response<dynamic> res = await get(
      '/api/customer/orders/$orderId/',
      headers: _headers(),
    );

    if (res.hasError) {
      print('!!! API Error on fetchOrderDetail: ${res.statusCode} - ${res.bodyString}');
       if (res.statusCode == 401) {
         throw 'خطای احراز هویت. لطفا مجددا وارد شوید.';
       }
      throw 'خطا در دریافت جزئیات سفارش (${res.statusCode})';
    }

    return MyOrderDetail.fromJson(res.body as Map<String, dynamic>);
  }
}
