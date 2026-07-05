// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // آیکون پیش‌فرض اندروید برای نوتیفیکیشن
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification({required int id, required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_messages', // شناسه کانال
      'پیام‌های چت', // نام کانال
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await _notificationsPlugin.show(id, title, body, platformDetails);
  }

  static Future<void> updateBadge(int count) async {
    // بررسی پشتیبانی گوشی از عدد روی آیکون
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      if (count > 0) {
        FlutterAppBadger.updateBadgeCount(count);
      } else {
        FlutterAppBadger.removeBadge();
      }
    }
  }

  static Future<void> clearBadge() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.removeBadge();
    }
  }
}
