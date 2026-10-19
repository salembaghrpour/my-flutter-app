import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../constants/api_constants.dart';
import '../../models/local/chat_message_local.dart';
import '../../services/notification_service.dart';
import 'chat_controller.dart';
import 'chat_sync_manager.dart';

class ChatWsManager {
  final ChatController controller;
  final ChatSyncManager syncManager;

  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  bool _connecting = false;
  int _session = 0;

  ChatWsManager(this.controller, this.syncManager);

  Future<void> connectWebSocket() async {
    if (controller.customerId.isEmpty || _connecting) return;

    final session = ++_session;
    final wsUrl =
        '${ApiConstants.wsUrl}/api/chat/ws/customer/${controller.customerId}';
    _connecting = true;
    controller.socketConnected.value = false;
    print('Customer WS connecting: $wsUrl');

    try {
      await _wsSubscription?.cancel();
      await _channel?.sink.close();

      final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channel = channel;

      _wsSubscription = channel.stream.listen((message) async {
        try {
          final decodedMessage = jsonDecode(message);

          if (decodedMessage['type'] == 'read_receipt') {
            _handleReadReceipt();
            return;
          }

          final sender =
              (decodedMessage['sender_type'] ?? decodedMessage['sender'] ?? 'admin')
                  .toString();
          final textContent = (decodedMessage['content'] ??
                  decodedMessage['text'] ??
                  '')
              .toString();
          final timestamp = (decodedMessage['created_at'] ??
                  decodedMessage['timestamp'] ??
                  DateTime.now().toIso8601String())
              .toString();
          final serverId = decodedMessage['id']?.toString();

          final messageType =
              (decodedMessage['message_type'] ?? 'text').toString();
          final fileUrl = decodedMessage['file_url'];
          final replyToIdStr = decodedMessage['reply_to_id']?.toString();
          final replyToIdInt =
              replyToIdStr != null ? int.tryParse(replyToIdStr) : null;

          final uniqueTempId =
              decodedMessage['original_client_id']?.toString() ??
                  decodedMessage['client_temp_id']?.toString();

          final alreadyExistsInUI = controller.messages.any((m) =>
              (serverId != null &&
                  m['server_id'] != null &&
                  m['server_id'].toString() == serverId) ||
              (uniqueTempId != null &&
                  m['client_temp_id']?.toString() == uniqueTempId) ||
              (m['text'] == textContent &&
                  m['sender'] == sender &&
                  m['timestamp'] == timestamp));

          if (alreadyExistsInUI) {
            return;
          }

          final localMsgs =
              await syncManager.localRepo.getMessagesByConversation(
            controller.customerId,
            limit: 100,
            offset: 0,
          );
          final alreadyExistsInDb = localMsgs.any((m) =>
              (serverId != null && m.serverId == serverId) ||
              (uniqueTempId != null && m.clientTempId == uniqueTempId) ||
              (m.content == textContent &&
                  m.senderType == sender &&
                  m.createdAt == timestamp));

          final chatOpen = controller.isChatScreenOpen.value;
          int? insertedLocalId;
          if (!alreadyExistsInDb) {
            insertedLocalId = await syncManager.localRepo.saveMessage(
              ChatMessageLocal(
                serverId: serverId,
                clientTempId: uniqueTempId,
                conversationId: controller.customerId,
                senderType: sender,
                content: textContent,
                createdAt: timestamp,
                isSynced: true,
                isRead: chatOpen,
                messageType: messageType,
                fileUrl: fileUrl,
                replyToId: replyToIdInt,
              ),
            );
          }

          controller.messages.add({
            'local_id': insertedLocalId,
            'server_id': serverId,
            'client_temp_id': uniqueTempId,
            'sender': sender,
            'text': textContent,
            'timestamp': timestamp,
            'status': 'sent',
            'is_read': chatOpen,
            'message_type': messageType,
            'file_url': fileUrl,
            'reply_to_id': replyToIdInt,
          });
          controller.sortMessages();

          final isFromSupport = sender != 'customer';
          if (isFromSupport) {
            if (!chatOpen) {
              controller.unreadCount.value =
                  controller.unreadCount.value + 1;
              print(
                  'Unread badge -> ${controller.unreadCount.value} (sender=$sender)');
              try {
                await NotificationService.updateBadge(
                    controller.unreadCount.value);
              } catch (e) {
                print('updateBadge error: $e');
              }
              try {
                await NotificationService.showNotification(
                  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  title: 'پیام جدید از پشتیبانی',
                  body: textContent.isEmpty ? 'پیام جدید' : textContent,
                );
              } catch (e) {
                print('showNotification error: $e');
              }
            } else {
              await controller.markAsRead();
            }
          }
        } catch (e) {
          print('WS Message Parsing Error: $e');
        }
      }, onDone: () {
        if (session != _session) return;
        controller.socketConnected.value = false;
        _connecting = false;
        reconnectWebSocket();
      }, onError: (e) {
        if (session != _session) return;
        print('Customer WS error: $e');
        controller.socketConnected.value = false;
        _connecting = false;
        reconnectWebSocket();
      });

      await channel.ready.timeout(const Duration(seconds: 8));
      if (session != _session) return;
      controller.socketConnected.value = true;
      print('Customer WS connected: $wsUrl');
    } catch (e) {
      if (session != _session) return;
      print('Customer WS failed: $e url=$wsUrl');
      controller.socketConnected.value = false;
      reconnectWebSocket();
    } finally {
      if (session == _session) {
        _connecting = false;
      }
    }
  }

  void reconnectWebSocket() {
    if (controller.customerId.isEmpty || controller.socketConnected.value) {
      return;
    }
    Future.delayed(const Duration(seconds: 5), () {
      if (!controller.socketConnected.value &&
          controller.customerId.isNotEmpty) {
        connectWebSocket();
      }
    });
  }

  void _handleReadReceipt() {
    for (var i = 0; i < controller.messages.length; i++) {
      controller.messages[i]['status'] = 'read';
      controller.messages[i]['is_read'] = true;
    }
    controller.messages.refresh();
  }

  void close() {
    _session++;
    _connecting = false;
    controller.socketConnected.value = false;
    _wsSubscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}
