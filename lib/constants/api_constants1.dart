// customer_app/lib/constants/api_constants.dart

class ApiConstants {
  // نام اپلیکیشن (اضافه شد)
  static const String appName = 'فروشگاه من';

  // آدرس پایه سرور (HTTP)
 //static const String baseUrl = 'http://127.0.0.1:8000';
 //static const String baseUrl = 'http://185.110.219.119:8000';
   // آدرس پایه سرور (HTTP) با دامنه جدید
  static const String baseUrl = 'http://app.koraarya.ir:8000';
  
  // آدرس پایه وب‌ساکت (WS)
  //static const String wsUrl = 'ws://127.0.0.1:8000';
 // static const String wsUrl = 'ws://185.110.219.119:8000';

    // آدرس پایه وب‌ساکت (WS) با دامنه جدید
 static const String wsUrl = 'ws://app.koraarya.ir:8000';


  // --- Endpoints ---
  
  // Auth
  static const String login = '$baseUrl/api/login';

  // Products
  static const String products = '$baseUrl/api/products/';

  // Chat
  // این تابع را بر اساس ساختار جدید (شامل user_type) اصلاح می‌کنیم
  static String chatHistory(String userType, String userId) => 
      '$baseUrl/api/chat/history/$userType/$userId';
  
  static String unreadCount(String userType, String userId) => 
      '$baseUrl/api/chat/unread_count/$userType/$userId';
}
