// lib/controllers/chat/chat_controller.dart
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../services/chat_service.dart';
import '../../services/notification_service.dart';
import '../../services/connectivity_service.dart';
import '../../models/local/chat_message_local.dart';
import '../../constants/api_constants.dart';
import '../auth_controller.dart';
import 'chat_sync_manager.dart';
import 'chat_ws_manager.dart';

class ChatController extends GetxController with WidgetsBindingObserver {
  var messages = <Map<String, dynamic>>[].obs;
  var unreadCount = 0.obs;
  var isConnected = false.obs;
  var socketConnected = false.obs;
  var isLoading = true.obs;
  var isChatScreenOpen = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreMessages = true.obs;

  var replyToMessage = Rxn<Map<String, dynamic>>();

  int limit = 20;
  int offset = 0;
  String customerId = '';
  final _uuid = const Uuid();

  late ConnectivityService _connectivityService;
  late ChatService _chatService;

  late ChatSyncManager _syncManager;
  late ChatWsManager _wsManager;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _connectivityService = Get.find<ConnectivityService>();
    _chatService = Get.find<ChatService>();

    _syncManager = ChatSyncManager(this, _chatService);
    _wsManager = ChatWsManager(this, _syncManager);

    isConnected.bindStream(_connectivityService.isConnected.stream);

    ever(isConnected, (bool connected) {
      if (connected && customerId.isNotEmpty) {
        _syncManager.syncOfflineMessages();
        _syncManager.pullServerMessages(isPagination: false);
        refreshUnreadCount();
        if (!socketConnected.value) {
          _wsManager.connectWebSocket();
        }
      }
    });

    final authController = Get.find<AuthController>();

    ever(authController.profileId, (String pId) {
      if (pId.isNotEmpty && pId != customerId) {
        ensureSession(pId);
      } else if (pId.isEmpty) {
        resetChat();
      }
    });

    if (authController.profileId.value.isNotEmpty) {
      ensureSession(authController.profileId.value);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && customerId.isNotEmpty) {
      refreshUnreadCount();
    }
  }

  Future<void> ensureSession(String id) async {
    final clean = id.trim();
    if (clean.isEmpty) return;

    if (clean == customerId) {
      if (!socketConnected.value) {
        _wsManager.connectWebSocket();
      }
      await refreshUnreadCount();
      return;
    }

    customerId = clean;
    await _initChat();
  }

  Map<String, dynamic>? getMessageById(dynamic id) {
    if (id == null) return null;
    try {
      return messages.firstWhere((m) =>
          m['server_id']?.toString() == id.toString() ||
          m['local_id']?.toString() == id.toString() ||
          m['id']?.toString() == id.toString());
    } catch (e) {
      return null;
    }
  }

  void setReplyMessage(Map<String, dynamic> message) {
    replyToMessage.value = message;
  }

  void cancelReply() {
    replyToMessage.value = null;
  }

  void resetChat() {
    _wsManager.close();
    customerId = '';
    messages.clear();
    unreadCount.value = 0;
    socketConnected.value = false;
    cancelReply();
  }

  Future<void> _initChat() async {
    isLoading.value = true;
    offset = 0;
    hasMoreMessages.value = true;
    messages.clear();

    try {
      try {
        await _syncManager.pullServerMessages(isPagination: false);
      } catch (e) {
        await _syncManager.loadMessagesFromLocal(isPagination: false);
      }
      await refreshUnreadCount();
    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading.value = false;
      _wsManager.connectWebSocket();
    }
  }

  bool _isCustomerMessage(Map<String, dynamic> message) {
    final sender = (message['sender_type'] ?? message['sender'] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    return sender == 'customer';
  }

  Future<void> refreshUnreadCount() async {
    if (customerId.isEmpty || isChatScreenOpen.value) return;

    final urls = <String>[
      ApiConstants.chatUnread('customer', customerId),
      '${ApiConstants.chatUnread('customer', customerId)}/',
    ];

    for (final url in urls) {
      try {
        final response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
        print('UNREAD $url -> ${response.statusCode} ${response.body}');
        if (response.statusCode != 200) continue;

        final data = jsonDecode(response.body);
        final raw = data is Map
            ? (data['unread_count'] ?? data['count'] ?? 0)
            : 0;
        final count = int.tryParse('$raw') ?? 0;

        // سرور فعلاً ۰ برمی‌گرداند؛ عدد سوکت را پاک نکن.
        if (count > unreadCount.value) {
          unreadCount.value = count;
          await NotificationService.updateBadge(count);
        }
        return;
      } catch (e) {
        print('UNREAD error $url -> $e');
      }
    }
  }


  void sortMessages() {
    messages.sort((a, b) {
      DateTime dtA = DateTime.tryParse(a['timestamp'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      DateTime dtB = DateTime.tryParse(b['timestamp'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return dtA.compareTo(dtB);
    });
  }

  Future<void> loadMoreMessages() async {
    if (isLoadingMore.value || !hasMoreMessages.value) return;
    isLoadingMore.value = true;
    offset += limit;

    try {
      try {
        await _syncManager.pullServerMessages(isPagination: true);
      } catch (e) {
        await _syncManager.loadMessagesFromLocal(isPagination: true);
      }
    } catch (e) {
      print("Error loading more messages: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> sendMessage(String text,
      {String messageType = 'text', String? fileUrl}) async {
    if (customerId.isEmpty) return;
    final timestamp = DateTime.now().toIso8601String();
    final String cTempId = 'cust_${customerId}_${_uuid.v4()}';

    int? rId;
    if (replyToMessage.value != null) {
      if (replyToMessage.value!['server_id'] != null) {
        rId = int.tryParse(replyToMessage.value!['server_id'].toString());
      } else if (replyToMessage.value!['id'] != null) {
        rId = int.tryParse(replyToMessage.value!['id'].toString());
      }
    }

    final localMsg = ChatMessageLocal(
      conversationId: customerId,
      clientTempId: cTempId,
      senderType: 'customer',
      content: text,
      createdAt: timestamp,
      isSynced: false,
      messageType: messageType,
      fileUrl: fileUrl,
      replyToId: rId,
    );

    final localId = await _syncManager.localRepo.saveMessage(localMsg);

    messages.add({
      "local_id": localId,
      "client_temp_id": cTempId,
      "sender": "customer",
      "sender_type": "customer",
      "text": text,
      "timestamp": timestamp,
      "status": "sending",
      "is_read": false,
      "message_type": messageType,
      "file_url": fileUrl,
      "reply_to_id": rId,
    });

    cancelReply();
    sortMessages();

    try {
      localMsg.localId = localId;
      final response = await _chatService.sendMessageToServer(localMsg);

      if (response != null && response['success'] == true) {
        await _syncManager.localRepo
            .markAsSynced(localId, response['server_id']?.toString() ?? '');
        updateMessageStatusUI(localId, "sent");

        int index = messages.indexWhere((m) => m['local_id'] == localId);
        if (index != -1) {
          messages[index]['server_id'] = response['server_id']?.toString();
          messages.refresh();
        }
      } else {
        updateMessageStatusUI(localId, "offline");
      }
    } catch (e) {
      updateMessageStatusUI(localId, "offline");
    }
  }

  void updateMessageStatusUI(dynamic localId, String status) {
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
    if (customerId.isEmpty) return;
    unreadCount.value = 0;
    NotificationService.clearBadge();

    for (var i = 0; i < messages.length; i++) {
      if (!_isCustomerMessage(messages[i])) {
        messages[i]['is_read'] = true;
      }
    }
    messages.refresh();

    await _syncManager.localRepo.markAdminMessagesAsRead(customerId);

    try {
      await _syncManager.markServerRead();
    } catch (e) {
      print("markAsRead server error: $e");
    }
  }

  void _calculateInitialUnreadCount() {
    unreadCount.value = messages
        .where((m) => !_isCustomerMessage(m) && m['is_read'] != true)
        .length;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _wsManager.close();
    super.onClose();
  }
}
