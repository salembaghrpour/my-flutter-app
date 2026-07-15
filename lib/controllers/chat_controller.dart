// D:\accounting_Arya\mobile_app\customer_app\lib\controllers\chat_controller.dart
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart'; 
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

  // متغیرهای مربوط به صفحه‌بندی
  var isLoadingMore = false.obs;
  var hasMoreMessages = true.obs;
  int _limit = 20;
  int _offset = 0;

  final ChatLocalRepository _localRepo = ChatLocalRepository();
  late ConnectivityService _connectivityService;
  late ChatService _chatService;
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  late String customerId;
  final _uuid = const Uuid(); 

  @override
  void onInit() {
    super.onInit();
    _connectivityService = Get.find<ConnectivityService>();
    _chatService = Get.find<ChatService>();

    isConnected.bindStream(_connectivityService.isConnected.stream);

    ever(isConnected, (bool connected) {
      if (connected && customerId.isNotEmpty) {
        _syncOfflineMessages();
        _pullServerMessages(isPagination: false); // دریافت پیام‌های جدید پس از اتصال
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
    _offset = 0;
    hasMoreMessages.value = true;
    messages.clear();

    try {
      if (_connectivityService.isConnected.value) {
        await _pullServerMessages(isPagination: false);
      } else {
        await _loadMessagesFromLocal(isPagination: false);
      }
      _calculateInitialUnreadCount();
    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading.value = false;
      _connectWebSocket();
    }
  }

  void _sortMessages() {
    messages.sort((a, b) {
      DateTime dtA = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      DateTime dtB = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dtA.compareTo(dtB);
    });
  }

  // متد جدید برای لود پیام‌های قدیمی هنگام اسکرول
  Future<void> loadMoreMessages() async {
    if (isLoadingMore.value || !hasMoreMessages.value) return;
    
    isLoadingMore.value = true;
    _offset += _limit;

    try {
      if (_connectivityService.isConnected.value) {
        await _pullServerMessages(isPagination: true);
      } else {
        await _loadMessagesFromLocal(isPagination: true);
      }
    } catch (e) {
      print("Error loading more messages: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _pullServerMessages({bool isPagination = false}) async {
    try {
      if (!isPagination) {
        _offset = 0;
        hasMoreMessages.value = true;
      }

      // اینجا limit و offset پاس داده می‌شود. متد getChatHistory در ChatService باید آپدیت شود.
      final history = await _chatService.getChatHistory(customerId, 'customer', limit: _limit, offset: _offset);
      
      if (history.length < _limit) {
        hasMoreMessages.value = false;
      }

      // دریافت پیام‌های لوکال فعلی برای مقایسه
      final localMsgs = await _localRepo.getMessagesByConversation(
        customerId, 
        limit: _limit, 
        offset: _offset
      );

      final existingServerIds = localMsgs
          .map((m) => m.serverId)
          .where((id) => id != null)
          .toSet();

      bool needsUiUpdate = false;

      for (var msgData in history) {
        final sId = msgData['server_id']?.toString() ?? msgData['id']?.toString();
        final cTempId = msgData['original_client_id']?.toString() ?? msgData['client_temp_id']?.toString(); 
        
        bool isReadOnServer = msgData['is_read'] == true || 
                              msgData['is_read'] == 1 || 
                              msgData['is_read'] == 'true' || 
                              msgData['is_read'] == '1';

        if (sId != null && !existingServerIds.contains(sId)) {
          final newLocalMsg = ChatMessageLocal(
            serverId: sId,
            clientTempId: cTempId, 
            conversationId: customerId,
            senderType: msgData['sender'] ?? msgData['sender_type'] ?? 'admin',
            content: msgData['text'] ?? msgData['content'] ?? '',
            createdAt: msgData['timestamp'] ?? msgData['created_at'] ?? DateTime.now().toIso8601String(),
            isSynced: true,
            isRead: isReadOnServer,
          );
          await _localRepo.saveMessage(newLocalMsg);
          needsUiUpdate = true;
        } else if (sId != null) {
          final existingMsgs = localMsgs.where((m) => m.serverId == sId);
          if (existingMsgs.isNotEmpty) {
            final msg = existingMsgs.first;
            if (!msg.isRead && isReadOnServer) {
              msg.isRead = true;
              await msg.save();
              needsUiUpdate = true;
            }
          }
        }
      }

      // همیشه پیام‌ها را پس از pull آپدیت می‌کنیم
      await _loadMessagesFromLocal(isPagination: isPagination);
      
    } catch (e) {
      print("Error pulling server messages: $e");
    }
  }

  Future<void> _loadMessagesFromLocal({bool isPagination = false}) async {
    if (!isPagination) {
      _offset = 0;
      hasMoreMessages.value = true;
      messages.clear();
    }

    // اینجا limit و offset پاس داده می‌شود. متد در ChatLocalRepository باید آپدیت شود.
    final localMsgs = await _localRepo.getMessagesByConversation(
      customerId, 
      limit: _limit, 
      offset: _offset
    );

    if (localMsgs.length < _limit) {
      hasMoreMessages.value = false;
    }

    _assignLocalMessages(localMsgs, isPagination: isPagination);
  }

  void _assignLocalMessages(List<ChatMessageLocal> localMsgs, {bool isPagination = false}) {
    var mappedList = localMsgs.map((m) {
      return {
        "local_id": m.localId,
        "server_id": m.serverId,
        "client_temp_id": m.clientTempId, 
        "sender": m.senderType,
        "text": m.content,
        "timestamp": m.createdAt,
        "status": !m.isSynced ? "offline" : (m.isRead ? "read" : "sent"),
        "is_read": m.isRead,
      };
    }).toList();
    
    if (isPagination) {
      // اضافه کردن پیام‌های قدیمی به ابتدای لیست
      var existingIds = messages.map((m) => m['local_id']).toSet();
      var newMessages = mappedList.where((m) => !existingIds.contains(m['local_id'])).toList();
      messages.insertAll(0, newMessages);
    } else {
      messages.assignAll(mappedList);
    }
    
    _sortMessages(); 
  }

  Future<void> _syncOfflineMessages() async {
    try {
      final localMsgs = await _localRepo.getMessagesByConversation(customerId, limit: 1000, offset: 0);
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
    unreadCount.value = messages.where((m) => (m['sender'] != 'customer' && m['is_read'] != true)).length;
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
          
          final uniqueTempId = decodedMessage['original_client_id']?.toString() ?? decodedMessage['client_temp_id']?.toString();

          bool alreadyExistsInUI = messages.any((m) => 
            (m['server_id'] != null && m['server_id'] == serverId) || 
            (uniqueTempId != null && m['client_temp_id'] == uniqueTempId) ||
            (m['text'] == textContent && m['sender'] == sender && m['timestamp'] == timestamp)
          );

          if (alreadyExistsInUI) return;

          // بررسی دیتابیس برای جلوگیری از ذخیره مجدد (محدودیت به ۱۰۰ تای آخر برای سرعت)
          final localMsgs = await _localRepo.getMessagesByConversation(customerId, limit: 100, offset: 0);
          bool alreadyExistsInDb = localMsgs.any((m) => 
             (serverId != null && m.serverId == serverId) || 
             (uniqueTempId != null && m.clientTempId == uniqueTempId) ||
             (m.content == textContent && m.senderType == sender && m.createdAt == timestamp)
          );

          if (!alreadyExistsInDb) {
            await _localRepo.saveMessage(ChatMessageLocal(
               serverId: serverId,
               clientTempId: uniqueTempId,
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
            "client_temp_id": uniqueTempId,
            "sender": sender,
            "text": textContent,
            "timestamp": timestamp,
            "status": "sent",
            "is_read": isChatScreenOpen.value,
          };
          messages.add(newMessage);
          _sortMessages(); 

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
      });
    } catch (e) {
      isConnected.value = false;
    }
  }

  void _reconnectWebSocket() {
    if (!isConnected.value) {
       Future.delayed(const Duration(seconds: 5), () {
         _connectWebSocket();
       });
    }
  }

  void _handleReadReceipt() async {
    for (var i = 0; i < messages.length; i++) {
       messages[i]['status'] = 'read';
       messages[i]['is_read'] = true;
    }
    messages.refresh();
  }

  Future<void> sendMessage(String text) async {
    final timestamp = DateTime.now().toIso8601String();
    
    final String cTempId = 'cust_${customerId}_${_uuid.v4()}';

    final localMsg = ChatMessageLocal(
      conversationId: customerId,
      clientTempId: cTempId, 
      senderType: 'customer',
      content: text,
      createdAt: timestamp,
      isSynced: false,
    );

    final localId = await _localRepo.saveMessage(localMsg);

    final tempMessage = {
      "local_id": localId,
      "client_temp_id": cTempId,
      "sender": "customer",
      "text": text,
      "timestamp": timestamp,
      "status": "sending",
      "is_read": false
    };
    messages.add(tempMessage);
    _sortMessages(); 

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
            messages.refresh();
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
      if (status == 'read') {
        messages[index]['is_read'] = true;
      }
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
