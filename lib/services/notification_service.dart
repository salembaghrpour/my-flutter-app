// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'js_stub.dart' if (dart.library.js) 'js_web.dart' as js; 

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return; 

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
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

  static Future<void> requestPermission() async {
    if (kIsWeb) {
      try {
        js.context.callMethod('requestWebNotificationPermission');
      } catch (e) {
        debugPrint('Web notification permission error: $e');
      }
      return;
    }

    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static Future<void> showNotification({required int id, required String title, required String body}) async {
    if (kIsWeb) {
      try {
        js.context.callMethod('showWebNotification', [title, body]);
      } catch (e) {
        debugPrint('Web notification show error: $e');
      }
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_messages', 
      'پیام‌های چت', 
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

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
    if (kIsWeb) {
      try {
        if (count > 0) {
          js.context.callMethod('updateWebBadge', [count]);
        } else {
          js.context.callMethod('clearWebBadge');
        }
      } catch (e) {
        debugPrint('Web badge update error: $e');
      }
      return; 
    }
    
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      if (count > 0) {
        FlutterAppBadger.updateBadgeCount(count);
      } else {
        FlutterAppBadger.removeBadge();
      }
    }
  }

  static Future<void> clearBadge() async {
    // صفر کردن حافظه لوکال شمارنده (حالا هم برای وب و هم موبایل اعمال می‌شود)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unread_badge_count', 0);

    if (kIsWeb) {
      try {
        js.context.callMethod('clearWebBadge');
      } catch (e) {
        debugPrint('Web badge clear error: $e');
      }
      return;
    }
    
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.removeBadge();
    }
  }
}
