// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
// ایمپورت شرطی جایگزین شد:
import 'js_stub.dart' if (dart.library.js) 'js_web.dart' as js; 

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return; // در وب نیازی به این پکیج نیست و با جاوااسکریپت هندل می‌شود

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // تنظیمات اولیه iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notificationsPlugin.initialize(settings);
  }

  // اضافه شدن متد درخواست مجوز
  static Future<void> requestPermission() async {
    if (kIsWeb) {
      // درخواست مجوز در وب (توسط اسکریپت داخل index.html)
      // نکته: در iOS 16.4+ این متد حتماً باید بعد از کلیک کاربر روی یک دکمه اجرا شود
      try {
        js.context.callMethod('requestWebNotificationPermission');
      } catch (e) {
        debugPrint('Web notification permission error: $e');
      }
      return;
    }

    // درخواست مجوز اندروید 13 به بالا (Tiramisu)
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    // درخواست مجوز iOS
    final iosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static Future<void> showNotification({required int id, required String title, required String body}) async {
    if (kIsWeb) {
      // نمایش نوتیفیکیشن در وب
      try {
        js.context.callMethod('showWebNotification', [title, body]);
      } catch (e) {
        debugPrint('Web notification show error: $e');
      }
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_messages', // شناسه کانال
      'پیام‌های چت', // نام کانال
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    // تنظیمات نمایش در iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.show(id, title, body, platformDetails);
  }

  static Future<void> updateBadge(int count) async {
    if (kIsWeb) return; // پکیج Badger در وب کار نمی‌کند
    
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      if (count > 0) {
        FlutterAppBadger.updateBadgeCount(count);
      } else {
        FlutterAppBadger.removeBadge();
      }
    }
  }

  static Future<void> clearBadge() async {
    if (kIsWeb) return;
    
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.removeBadge();
    }
  }
}
