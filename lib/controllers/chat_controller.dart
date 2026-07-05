// lib/controllers/chat_controller.dart
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import '../services/chat_service.dart';
import '../services/notification_service.dart'; // اضافه شدن سرویس نوتیفیکیشن
import 'auth_controller.dart';

class ChatController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;
  var unreadCount = 0.obs;
  var isConnected = false.obs;
  var isLoading = true.obs;
  var isChatScreenOpen = false.obs;
  
  WebSocketChannel? _channel;
  late String customerId;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();

    if (authController.profileId.value.isNotEmpty) {
      customerId = authController.profileId.value;
      _initChat();
    } else {
      once(
        authController.profileId,
        (String pId) {
          customerId = pId;
          _initChat();
        },
        condition: () => authController.profileId.value.isNotEmpty,
      );
    }
  }

  Future<void> _initChat() async {
    isLoading.value = true;
    try {
      final history = await ChatService.getChatHistory(customerId, 'customer');
      messages.assignAll(history);
      
      _calculateInitialUnreadCount();
    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading.value = false;
      _connectWebSocket();
    }
  }

  void _calculateInitialUnreadCount() {
    try {
      int count = 0;
      for (var message in messages) {
        bool isRead = false;
        if (message.containsKey('is_read')) {
          var readVal = message['is_read'];
          if (readVal is bool) {
            isRead = readVal;
          } else if (readVal is int) {
            isRead = readVal == 1; 
          }
        }
        
        String sender = message['sender_type'] ?? message['sender'] ?? 'admin';
        if (!isRead && sender != 'customer') {
          count++;
        }
      }
      
      unreadCount.value = count;
      // آپدیت عدد روی آیکون اپ در ابتدای ورود
      NotificationService.updateBadge(count); 
    } catch (e) {
      print("خطا در محاسبه تعداد پیام‌های نخوانده: $e");
    }
  }

  void _connectWebSocket() {
    final wsUrl = '${ApiConstants.wsUrl}/api/chat/ws/customer/$customerId';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    isConnected.value = true;

    _channel!.stream.listen((message) {
      try {
        final decodedMessage = jsonDecode(message);
        final msgType = decodedMessage['type'] ?? "new_message";

        if (msgType == "read_receipt") {
          for (var i = 0; i < messages.length; i++) {
            if (messages[i]['sender'] == "customer") {
              messages[i]['is_read'] = true;
              messages[i]['status'] = "read";
            }
          }
          messages.refresh();
          return;
        }

        final sender = decodedMessage['sender_type'] ?? "admin";
        final textContent = decodedMessage['content'] ?? "";
        
        messages.add({
          "sender": sender,
          "text": textContent,
          "timestamp": decodedMessage['created_at'] ?? DateTime.now().toIso8601String(),
          "status": "sent",
          "is_read": false,
        });

        if (sender == "admin") {
          if (!isChatScreenOpen.value) {
            unreadCount.value++;
            
            // نمایش نوتیفیکیشن سیستم و آپدیت عدد آیکون
            NotificationService.showNotification(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000, 
              title: 'پیام جدید از پشتیبانی', 
              body: textContent
            );
            NotificationService.updateBadge(unreadCount.value);
            
          } else {
            markAsRead();
          }
        }
      } catch (e) {
        print("WS Error: $e");
      }
    }, onDone: () {
      isConnected.value = false;
    }, onError: (e) {
      isConnected.value = false;
    });
  }

  Future<void> sendMessage(String text) async {
    messages.add({
      "sender": "customer",
      "text": text,
      "timestamp": DateTime.now().toIso8601String(),
      "status": "sent",
      "is_read": false
    });

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/chat/send');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_type": "customer",
          "sender_type": "customer",
          "content": text,
          "user_id": customerId,
        }),
      );
    } catch (e) {
      print("خطای ارتباط در ارسال پیام: $e");
    }
  }

  Future<void> markAsRead() async {
    unreadCount.value = 0;
    
    // پاک کردن عدد از روی آیکون برنامه
    NotificationService.clearBadge();
    
    for (var i = 0; i < messages.length; i++) {
      String sender = messages[i]['sender_type'] ?? messages[i]['sender'] ?? 'admin';
      if (sender != 'customer') {
        messages[i]['is_read'] = true;
      }
    }
    messages.refresh();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/chat/read_messages');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": customerId,
          "user_type": "customer",
          "reader_type": "customer",
        }),
      );
    } catch (e) {
      print("خطا در ارسال وضعیت خوانده شده به سرور: $e");
    }
  }

  @override
  void onClose() {
    _channel?.sink.close();
    super.onClose();
  }
}
