// lib/core/constants.dart

class AppConstants {
  static const String appName = 'فروشگاه من';
  
  // آدرس سرور FastAPI لوکال برای تست روی مرورگر (وب)
  // نکته: اگر روی شبیه‌ساز اندروید اجرا می‌کنید، این مقادیر را به 10.0.2.2 تغییر دهید
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  // این خط برای رفع خطای Member not found به فایل اضافه شد
  static const String apiBaseUrl = 'http://127.0.0.1:8000';
  
  static const String wsBaseUrl = 'ws://127.0.0.1:8000';
}
