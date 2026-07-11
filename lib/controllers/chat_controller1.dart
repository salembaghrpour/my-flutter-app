// lib/controllers/chat_controller.dart
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../constants/api_constants.dart';
import '../services/chat_service.dart';
import '../services/notification_service.dart';
import '../services/local_db/chat_local_repository.dart';
import '../services/connectivity_service.dart';
import '../models/local/chat_message_local.dart';
import 'auth_controller.dart';

class ChatController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;
  var unreadCount = 0.obs;
  var isConnected = false.obs;
  var isLoading = true.obs;
  var isChatScreenOpen = false.obs;

  final ChatLocalRepository _localRepo = ChatLocalRepository();
  late ConnectivityService _connectivityService;
  late ChatService _chatService;
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  late String customerId;

  @override
  void onInit() {
    super.onInit();
    _connectivityService = Get.find<ConnectivityService>();
    _chatService = Get.find<ChatService>();

    isConnected.bindStream(_connectivityService.isConnected.stream);

    ever(isConnected, (bool connected) {
      if (connected && customerId.isNotEmpty) {
        _syncOfflineMessages();
        _pullServerMessages();
      }
    });

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
      if (_connectivityService.isConnected.value) {
        await _pullServerMessages();
      } else {
        await _loadMessagesFromLocal();
      }
      _calculateInitialUnreadCount();
    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading.value = false;
      _connectWebSocket();
    }
  }

  Future<void> _pullServerMessages() async {
    try {
      final history = await _chatService.getChatHistory(customerId, 'customer');
      final localMsgs = await _localRepo.getMessagesByConversation(customerId);

      final existingServerIds = localMsgs
          .map((m) => m.serverId)
          .where((id) => id != null)
          .toSet();

      for (var msgData in history) {
        final sId = msgData['server_id']?.toString();
        if (sId != null && !existingServerIds.contains(sId)) {
          final newLocalMsg = ChatMessageLocal(
            serverId: sId,
            conversationId: customerId,
            senderType: msgData['sender'] ?? 'admin',
            content: msgData['text'] ?? '',
            createdAt: msgData['timestamp'] ?? DateTime.now().toIso8601String(),
            isSynced: true,
            isRead: msgData['is_read'] == true || msgData['is_read'] == 1,
          );
          await _localRepo.saveMessage(newLocalMsg);
        }
      }

      await _loadMessagesFromLocal();
    } catch (e) {
      print("Error pulling server messages: $e");
    }
  }

  Future<void> _loadMessagesFromLocal() async {
    final localMsgs = await _localRepo.getMessagesByConversation(customerId);
    localMsgs.sort((a, b) => (a.createdAt).compareTo(b.createdAt));
    _assignLocalMessages(localMsgs);
  }

  void _assignLocalMessages(List<ChatMessageLocal> localMsgs) {
    messages.assignAll(localMsgs.map((m) {
      return {
        "local_id": m.localId,
        "server_id": m.serverId,
        "sender": m.senderType,
        "text": m.content,
        "timestamp": m.createdAt,
        "status": !m.isSynced ? "offline" : (m.isRead ? "read" : "sent"),
        "is_read": m.isRead,
      };
    }).toList());
  }

  Future<void> _syncOfflineMessages() async {
    try {
      final localMsgs = await _localRepo.getMessagesByConversation(customerId);
      final unsyncedMsgs = localMsgs.where((m) => !m.isSynced).toList();

      for (var msg in unsyncedMsgs) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (msg.localId != null) {
          _updateMessageStatusUI(msg.localId, "sending");

          final response = await _chatService.sendMessageToServer(msg);
          if (response != null && response['success'] == true) {
            await _localRepo.markAsSynced(msg.localId!, response['server_id']?.toString() ?? '');
            _updateMessageStatusUI(msg.localId, "sent");
          } else {
            _updateMessageStatusUI(msg.localId, "offline");
          }
        }
      }
    } catch (e) {
      print("Error syncing offline messages: $e");
    }
  }

  void _calculateInitialUnreadCount() {
    try {
      int count = 0;
      for (var message in messages) {
        bool isRead = message['is_read'] == true || message['is_read'] == 1;
        String sender = message['sender_type'] ?? message['sender'] ?? 'admin';
        if (!isRead && sender != 'customer') {
          count++;
        }
      }
      unreadCount.value = count;
      NotificationService.updateBadge(count);
    } catch (e) {
      print("خطا در محاسبه تعداد پیام‌های نخوانده: $e");
    }
  }

  void _connectWebSocket() {
    if (customerId.isEmpty) return;

    final wsUrl = '${ApiConstants.wsUrl}/api/chat/ws/customer/$customerId';
    
    try {
      _wsSubscription?.cancel();
      _channel?.sink.close();

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      isConnected.value = true;

      _wsSubscription = _channel!.stream.listen((message) async {
        try {
          final decodedMessage = jsonDecode(message);
          
          if (decodedMessage['type'] == "read_receipt") {
            _handleReadReceipt();
            return;
          }

          final sender = decodedMessage['sender_type'] ?? "admin";
          final textContent = decodedMessage['content'] ?? "";
          final timestamp = decodedMessage['created_at'] ?? DateTime.now().toIso8601String();
          final serverId = decodedMessage['id']?.toString();

          bool alreadyExistsInUI = messages.any((m) => 
            (m['server_id'] != null && m['server_id'] == serverId) || 
            (m['text'] == textContent && m['sender'] == sender && m['timestamp'] == timestamp)
          );

          if (alreadyExistsInUI) return;

          final localMsgs = await _localRepo.getMessagesByConversation(customerId);
          bool alreadyExistsInDb = localMsgs.any((m) => 
             (serverId != null && m.serverId == serverId) || 
             (m.content == textContent && m.senderType == sender && m.createdAt == timestamp)
          );

          if (!alreadyExistsInDb) {
            await _localRepo.saveMessage(ChatMessageLocal(
               serverId: serverId,
               conversationId: customerId,
               senderType: sender,
               content: textContent,
               createdAt: timestamp,
               isSynced: true,
               isRead: isChatScreenOpen.value,
            ));
          }

          final newMessage = {
            "server_id": serverId,
            "sender": sender,
            "text": textContent,
            "timestamp": timestamp,
            "status": "sent",
            "is_read": isChatScreenOpen.value,
          };
          messages.add(newMessage);

          if (sender == "admin") {
            if (!isChatScreenOpen.value) {
              unreadCount.value++;
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
          print("WS Message Parsing Error: $e");
        }
      }, onDone: () {
        isConnected.value = false;
        _reconnectWebSocket();
      }, onError: (e) {
        isConnected.value = false;
        print("WS Error: $e");
      });
    } catch (e) {
      isConnected.value = false;
      print("WS Connection Error: $e");
    }
  }

  void _reconnectWebSocket() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!isConnected.value && !isClosed) {
        _connectWebSocket();
      }
    });
  }

  void _handleReadReceipt() async {
    for (var i = 0; i < messages.length; i++) {
      if (messages[i]['sender'] == "customer") {
        messages[i]['is_read'] = true;
        messages[i]['status'] = "read";
      }
    }
    messages.refresh();
    // ثبت تیک‌های آبی پیام‌های ما در دیتابیس لوکال
    await _localRepo.markAllCustomerMessagesAsRead(customerId);
  }

  Future<void> sendMessage(String text) async {
    final timestamp = DateTime.now().toIso8601String();

    final localMsg = ChatMessageLocal(
      conversationId: customerId,
      senderType: 'customer',
      content: text,
      createdAt: timestamp,
      isSynced: false,
    );

    final localId = await _localRepo.saveMessage(localMsg);

    final tempMessage = {
      "local_id": localId,
      "sender": "customer",
      "text": text,
      "timestamp": timestamp,
      "status": "sending",
      "is_read": false
    };
    messages.add(tempMessage);

    if (_connectivityService.isConnected.value) {
      try {
        localMsg.localId = localId;

        final response = await _chatService.sendMessageToServer(localMsg);

        if (response != null && response['success'] == true) {
          await _localRepo.markAsSynced(localId, response['server_id']?.toString() ?? '');
          _updateMessageStatusUI(localId, "sent");
          
          int index = messages.indexWhere((m) => m['local_id'] == localId);
          if (index != -1) {
            messages[index]['server_id'] = response['server_id']?.toString();
          }
        } else {
          _updateMessageStatusUI(localId, "offline");
        }
      } catch (e) {
        _updateMessageStatusUI(localId, "offline");
      }
    } else {
      _updateMessageStatusUI(localId, "offline");
    }
  }

  void _updateMessageStatusUI(dynamic localId, String status) {
    int index = messages.indexWhere((m) => m['local_id'] == localId);
    if (index != -1) {
      messages[index]['status'] = status;
      messages.refresh();
    }
  }

  Future<void> markAsRead() async {
    unreadCount.value = 0;
    NotificationService.clearBadge();

    for (var i = 0; i < messages.length; i++) {
      String sender = messages[i]['sender_type'] ?? messages[i]['sender'] ?? 'admin';
      if (sender != 'customer') {
        messages[i]['is_read'] = true;
      }
    }
    messages.refresh();
    
    // ثبت خوانده شدن پیام‌های ادمین در دیتابیس لوکال
    await _localRepo.markAdminMessagesAsRead(customerId);

    if (_connectivityService.isConnected.value) {
      try {
        await http.post(
          Uri.parse('${ApiConstants.baseUrl}/api/chat/read_messages'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "user_id": customerId,
            "user_type": "customer",
            "reader_type": "customer",
          }),
        );
      } catch (e) {
        print("Error marking as read: $e");
      }
    }
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    _channel?.sink.close();
    super.onClose();
  }
}
