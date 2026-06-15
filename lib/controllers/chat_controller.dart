// lib/controllers/chat_controller.dart
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constants.dart';
import '../services/chat_service.dart';
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
    customerId = authController.profileId.value;
    _initChat();
  }

  Future<void> _initChat() async {
    isLoading.value = true;
    
    // گرفتن تعداد پیام‌های نخوانده در زمان بالا آمدن اپلیکیشن
    await _fetchInitialUnreadCount();
    
    final history = await ChatService.getChatHistory(customerId);
    messages.assignAll(history);
    isLoading.value = false;
    _connectWebSocket();
  }

  // ---- تابع جدید برای دریافت پیام‌های نخوانده از دیتابیس ----
  Future<void> _fetchInitialUnreadCount() async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/chat/unread_count/$customerId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        unreadCount.value = data['unread_count'] ?? 0;
      }
    } catch (e) {
      print("خطا در دریافت تعداد پیام‌های نخوانده: $e");
    }
  }
  // ------------------------------------------------------------

  void _connectWebSocket() {
    final wsUrl = '${AppConstants.wsBaseUrl}/api/chat/ws/customer/$customerId';
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
        
        messages.add({
          "sender": sender,
          "text": decodedMessage['content'] ?? "",
          "timestamp": decodedMessage['created_at'] ?? DateTime.now().toIso8601String(),
          "status": "sent",
          "is_read": false,
        });

        if (sender == "admin") {
          if (!isChatScreenOpen.value) {
            unreadCount.value++;
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
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/chat/send');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "sender_type": "customer",
          "content": text,
          "customer_id": customerId,
        }),
      );
    } catch (e) {
      print("خطای ارتباط: $e");
    }
  }

  Future<void> markAsRead() async {
    unreadCount.value = 0;
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/chat/read_messages');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "customer_id": customerId,
          "reader_type": "customer",
        }),
      );
    } catch (e) {
      print("خطا در ارسال وضعیت خوانده شده: $e");
    }
  }

  @override
  void onClose() {
    _channel?.sink.close();
    super.onClose();
  }
}
