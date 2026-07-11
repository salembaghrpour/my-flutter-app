// customer_app/lib/constants/api_constants.dart

class ApiConstants {
  // نام اپلیکیشن (اضافه شد)
  static const String appName = 'فروشگاه من';

  // آدرس پایه سرور (HTTPS) - پورت 8000 حذف و http به https تبدیل شد
  static const String baseUrl = 'https://app.koraarya.ir';
 // static const String baseUrl = 'http://127.0.0.1:8000';
  
  // آدرس پایه وب‌ساکت (WSS) - برای وب‌ساکت امن باید از wss استفاده کنید
  static const String wsUrl = 'wss://app.koraarya.ir';
  //static const String wsUrl = 'ws://127.0.0.1:8000';



  // --- Endpoints ---
  
  // Auth
  static const String login = '$baseUrl/api/login';

  // Products
  static const String products = '$baseUrl/api/products/';

  // Chat
  static String chatHistory(String userType, String userId) => 
      '$baseUrl/api/chat/history/$userType/$userId';
  
  static String unreadCount(String userType, String userId) => 
      '$baseUrl/api/chat/unread_count/$userType/$userId';
}
