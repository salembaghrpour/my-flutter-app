import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'core/constants.dart';
import 'screens/product_list_screen.dart';
import 'screens/login_screen.dart'; 
import 'main_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName ?? 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // سرمه‌ای
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFF59E0B), // طلایی/نارنجی برای آیکون‌ها و قیمت‌ها
          surface: const Color(0xFFF3F4F6), // رنگ پس‌زمینه ملایم
        ),
        useMaterial3: true,
        fontFamily: 'Tahoma', 
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white, // رنگ متن و آیکون‌های هدر
        ),
        // تغییر به CardThemeData برای سازگاری با نسخه‌های جدید فلاتر
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // گوشه‌های گرد (Pill-shape)
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2), // سایه نرم
        ),
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/products', page: () => ProductListScreen()),
        GetPage(name: '/main', page: () => const MainScreen()), 
      ],
    );
  }
}
