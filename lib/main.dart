// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/chat_controller.dart';
import 'constants/api_constants.dart';
import 'screens/product_list_screen.dart';
import 'screens/login_screen.dart';
import 'main_screen.dart';
import 'services/storage_service.dart';
import 'controllers/auth_controller.dart';
import 'services/notification_service.dart';
import 'services/connectivity_service.dart';
import 'services/chat_service.dart';
import 'services/sync/chat_sync_service.dart';
import 'services/order_sync_service.dart'; 
import 'core/local/db/app_database.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- تنظیمات دیتابیس‌های محلی (Drift و Hive) ---
  await AppDatabase.initializeLocalDatabases();
  // --------------------

  await NotificationService.init();
  
  // فراخوانی درخواست دسترسی نوتیفیکیشن در زمان باز شدن اپ
  await NotificationService.requestPermission();

  await Get.putAsync(() => StorageService().init());
  
  // ترتیب مهم است: سرویس‌های پایه، بعد سرویس‌های همگام‌سازی
  Get.put(ChatService());
  Get.put(ConnectivityService(), permanent: true);
  Get.put(ChatSyncService(), permanent: true);
  // ثبت سرویس همگام‌سازی سفارشات برای اجرای خودکار پس از اتصال
  Get.put(OrderSyncService(), permanent: true); 

  Get.put(AuthController());
  Get.put(ChatController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    final String initialRoute = storageService.isLoggedIn ? '/main' : '/login';

    return GetMaterialApp(
      title: ApiConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
        fontFamily: 'Tahoma', 
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
