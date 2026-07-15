// D:\accounting_Arya\mobile_app\customer_app\lib\services\auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../constants/api_constants.dart';

class AuthService {
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
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
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error connecting to the server: $e');
      throw Exception('خطا در ارتباط با سرور: $e');
    }
  }

  // متد اصلاح شده برای ارسال توکن FCM به سرور
  Future<bool> updateFcmToken(int userId, String fcmToken) async {
    try {
      // تغییر به آدرس دقیق بک‌اند و استفاده از POST
      final url = Uri.parse('${ApiConstants.baseUrl}/api/update-fcm-token');
      
      final response = await http.post(
        url, 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'fcm_token': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ FCM Token updated successfully in backend');
        return true;
      } else {
        print('❌ Failed to update FCM Token: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating FCM token: $e');
      return false;
    }
  }

}
