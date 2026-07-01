// lib/controllers/chat_controller.dart
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart'; // اصلاح شد
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

    // بررسی می‌کنیم که آیا profileId از قبل آماده است یا خیر
    if (authController.profileId.value.isNotEmpty) {
      // حالت اول: profileId آماده است
      customerId = authController.profileId.value;
      _initChat();
    } else {
      // حالت دوم: profileId هنوز در حال خوانده شدن از حافظه است
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
      // ۱. ابتدا تاریخچه پیام‌ها را دریافت می‌کنیم
      final history = await ChatService.getChatHistory(customerId, 'customer');
      messages.assignAll(history);
      
      // ۲. محاسبه تعداد پیام‌های نخوانده از روی تاریخچه پیام‌ها
      _calculateInitialUnreadCount();
      
    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading.value = false;
      // ۳. در نهایت وب‌سوکت را متصل می‌کنیم
      _connectWebSocket();
    }
  }

  // ---- تابع جدید برای شمارش پیام‌های نخوانده از روی لیست موجود ----
  void _calculateInitialUnreadCount() {
    try {
      int count = 0;
      for (var message in messages) {
        // دریافت وضعیت خوانده شدن
        bool isRead = false;
        if (message.containsKey('is_read')) {
          var readVal = message['is_read'];
          if (readVal is bool) {
            isRead = readVal;
          } else if (readVal is int) {
            isRead = readVal == 1; // در برخی دیتابیس‌ها به شکل 0 و 1 می‌آید
          }
        }
        
        // پیدا کردن فرستنده پیام
        String sender = message['sender_type'] ?? message['sender'] ?? 'admin';
        
        // اگر پیام خوانده نشده و فرستنده مشتری نیست (پیام از سمت پشتیبانی است)
        if (!isRead && sender != 'customer') {
          count++;
        }
      }
      
      unreadCount.value = count;
    } catch (e) {
      print("خطا در محاسبه تعداد پیام‌های نخوانده: $e");
    }
  }
  // ------------------------------------------------------------------

  void _connectWebSocket() {
    final wsUrl = '${ApiConstants.wsUrl}/api/chat/ws/customer/$customerId'; // اصلاح شد
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
      final url = Uri.parse('${ApiConstants.baseUrl}/api/chat/send'); // اصلاح شد
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
    // ۱. صفر کردن شمارنده
    unreadCount.value = 0;
    
    // ۲. به‌روزرسانی وضعیت پیام‌ها در لیست محلی تا با باز و بسته کردن دوباره نشمارد
    for (var i = 0; i < messages.length; i++) {
      String sender = messages[i]['sender_type'] ?? messages[i]['sender'] ?? 'admin';
      if (sender != 'customer') {
        messages[i]['is_read'] = true;
      }
    }
    messages.refresh();

    // ۳. ارسال درخواست به سرور
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/chat/read_messages'); // اصلاح شد
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
