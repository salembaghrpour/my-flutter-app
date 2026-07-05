// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/chat_controller.dart';
import 'constants/api_constants.dart'; // اصلاح شد
import 'screens/product_list_screen.dart';
import 'screens/login_screen.dart';
import 'main_screen.dart';
import 'services/storage_service.dart';
import 'controllers/auth_controller.dart';
import 'services/notification_service.dart'; // اضافه شدن سرویس نوتیفیکیشن

void main() async {
  // اطمینان از مقداردهی اولیه ویجت‌ها در فلاتر
  WidgetsFlutterBinding.ensureInitialized();

  // راه‌اندازی نوتیفیکیشن‌های محلی
  await NotificationService.init();

  // ۱. راه‌اندازی StorageService قبل از اجرای اپلیکیشن
  await Get.putAsync(() => StorageService().init());

  // ۲. ایجاد کنترلر AuthController در مموری برای لاگین
  Get.put(AuthController());

  // ۳. ایجاد ChatController به صورت دائمی (permanent)
  // این کنترلر از ابتدا آماده خواهد بود و با تغییرات لاگین، وب‌سوکت را مقداردهی می‌کند
  Get.put(ChatController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // خواندن وضعیت لاگین از سرویس برای تعیین صفحه شروع
    final storageService = Get.find<StorageService>();
    final String initialRoute = storageService.isLoggedIn ? '/main' : '/login';

    return GetMaterialApp(
      title: ApiConstants.appName, // اصلاح شد
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // سرمه‌ای
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFF59E0B), // طلایی/نارنجی
          surface: const Color(0xFFF3F4F6), // رنگ پس‌زمینه
        ),
        useMaterial3: true,
        fontFamily: 'Tahoma',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white, 
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
      ),
      initialRoute: initialRoute, 
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/products', page: () => ProductListScreen()),
        GetPage(name: '/main', page: () => const MainScreen()), 
      ],
    );
  }
}
