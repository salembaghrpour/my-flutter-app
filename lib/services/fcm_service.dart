// lib/services/fcm_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); 
  
  final prefs = await SharedPreferences.getInstance();
  int currentBadge = prefs.getInt('unread_badge_count') ?? 0;
  currentBadge++;
  await prefs.setInt('unread_badge_count', currentBadge);

  await NotificationService.updateBadge(currentBadge);
}

class FCMService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // خط if (kIsWeb) return حذف شد تا در PWA هم کار کند

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('FCM: User granted permission');
    }

    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Device Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');
      
      if (message.notification != null) {
        // هندل کردن پیام در وضعیت باز بودن اپ (بر عهده ChatController و سوکت)
      }
    });
  }
}
