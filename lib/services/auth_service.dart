// D:\accounting_Arya\mobile_app\customer_app\lib\services\auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
// import '../core/constants.dart'; // در صورت نیاز از کامنت خارج کنید

class AuthService {
  // برای اجرا در مرورگر (Chrome) و ویندوز از 127.0.0.1 استفاده می‌کنیم
  static const String baseUrl = 'http://127.0.0.1:8000'; 

  Future<UserModel?> login(String username, String password) async {
    try {
      // چون در بک‌اند prefix="/api" قرار دادید، اینجا هم باید /api/login باشد
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        // برای دیباگ بهتر، کد خطا را چاپ کنید
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error connecting to the server: $e'); // چاپ خطا در کنسول فلاتر
      throw Exception('خطا در ارتباط با سرور: $e');
    }
  }
}
