// lib/services/fcm_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/chat/chat_controller.dart';
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
      final notification = message.notification;
      if (notification == null) return;
      if (!Get.isRegistered<ChatController>()) return;

      final chat = Get.find<ChatController>();
      if (chat.isChatScreenOpen.value) return;

      // اگر سوکت وصل است، خودِ ChatController شمارنده را زیاد می‌کند.
      if (!chat.socketConnected.value) {
        chat.unreadCount.value++;
        await NotificationService.updateBadge(chat.unreadCount.value);
      }

      await NotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: notification.title ?? 'پیام جدید از پشتیبانی',
        body: notification.body ?? '',
      );
    });
  }
}
