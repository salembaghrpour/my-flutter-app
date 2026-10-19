// D:\accounting_Arya\mobile_app\customer_app\lib\controllers\chat\chat_sync_manager.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../services/chat_service.dart';
import '../../services/local_db/chat_local_repository.dart';
import '../../models/local/chat_message_local.dart';
import 'chat_controller.dart';

class ChatSyncManager {
  final ChatController controller;
  final ChatLocalRepository localRepo = ChatLocalRepository();
  final ChatService chatService;

  ChatSyncManager(this.controller, this.chatService);

  Future<void> pullServerMessages({bool isPagination = false}) async {
    if (controller.customerId.isEmpty) return; 
    try {
      if (!isPagination) {
        controller.offset = 0;
        controller.hasMoreMessages.value = true;
      }

      final history = await chatService.getChatHistory(
        controller.customerId, 'customer', 
        limit: controller.limit, 
        offset: controller.offset
      );
      
      if (history.length < controller.limit) {
        controller.hasMoreMessages.value = false;
      }

      final localMsgs = await localRepo.getMessagesByConversation(
        controller.customerId, limit: controller.limit, offset: controller.offset
      );

      final existingServerIds = localMsgs.map((m) => m.serverId).where((id) => id != null).toSet();

      for (var msgData in history) {
        final sId = msgData['server_id']?.toString() ?? msgData['id']?.toString();
        final cTempId = msgData['original_client_id']?.toString() ?? msgData['client_temp_id']?.toString(); 
        
        bool isReadOnServer = msgData['is_read'] == true || msgData['is_read'] == 1 || msgData['is_read'] == 'true' || msgData['is_read'] == '1';

        if (sId != null && !existingServerIds.contains(sId)) {
          final newLocalMsg = ChatMessageLocal(
            serverId: sId,
            clientTempId: cTempId, 
            conversationId: controller.customerId,
            senderType: msgData['sender'] ?? msgData['sender_type'] ?? 'admin',
            content: msgData['text'] ?? msgData['content'] ?? '',
            createdAt: msgData['timestamp'] ?? msgData['created_at'] ?? DateTime.now().toIso8601String(),
            isSynced: true,
            isRead: isReadOnServer,
            // پارامترهای جدید اضافه شدند
            messageType: msgData['message_type'] ?? 'text',
            fileUrl: msgData['file_url'],
            replyToId: msgData['reply_to_id'] != null ? int.tryParse(msgData['reply_to_id'].toString()) : null,
          );
          await localRepo.saveMessage(newLocalMsg);
        } else if (sId != null) {
          final existingMsgs = localMsgs.where((m) => m.serverId == sId);
          if (existingMsgs.isNotEmpty) {
            final msg = existingMsgs.first;
            if (!msg.isRead && isReadOnServer) {
              msg.isRead = true;
              await msg.save();
            }
          }
        }
      }

      await loadMessagesFromLocal(isPagination: isPagination);
      
    } catch (e) {
      print("Error pulling server messages: $e");
    }
  }

  Future<void> loadMessagesFromLocal({bool isPagination = false}) async {
    if (controller.customerId.isEmpty) return; 
    if (!isPagination) {
      controller.offset = 0;
      controller.hasMoreMessages.value = true;
      controller.messages.clear();
    }

    final localMsgs = await localRepo.getMessagesByConversation(
      controller.customerId, limit: controller.limit, offset: controller.offset
    );

    if (localMsgs.length < controller.limit) {
      controller.hasMoreMessages.value = false;
    }

    assignLocalMessages(localMsgs, isPagination: isPagination);
  }

  void assignLocalMessages(List<ChatMessageLocal> localMsgs, {bool isPagination = false}) {
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
        // مقادیر ریپلای و نوع پیام به رابط کاربری پاس داده شد
        "message_type": m.messageType ?? 'text',
        "file_url": m.fileUrl,
        "reply_to_id": m.replyToId,
      };
    }).toList();
    
    if (isPagination) {
      var existingLocalIds = controller.messages.map((m) => m['local_id']).where((id) => id != null).toSet();
      var existingServerIds = controller.messages.map((m) => m['server_id']).where((id) => id != null).toSet();
      var existingTempIds = controller.messages.map((m) => m['client_temp_id']).where((id) => id != null).toSet();

      var newMessages = mappedList.where((m) {
        bool matchLocal = m['local_id'] != null && existingLocalIds.contains(m['local_id']);
        bool matchServer = m['server_id'] != null && existingServerIds.contains(m['server_id']);
        bool matchTemp = m['client_temp_id'] != null && existingTempIds.contains(m['client_temp_id']);
        
        return !matchLocal && !matchServer && !matchTemp;
      }).toList();
      
      controller.messages.insertAll(0, newMessages);
    } else {
      controller.messages.clear();
      controller.messages.addAll(mappedList.toList());
    }
    
    controller.sortMessages(); 
  }

  Future<void> syncOfflineMessages() async {
    if (controller.customerId.isEmpty) return;
    try {
      final localMsgs = await localRepo.getMessagesByConversation(controller.customerId, limit: 1000, offset: 0);
      final unsyncedMsgs = localMsgs.where((m) => !m.isSynced).toList();

      for (var msg in unsyncedMsgs) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (msg.localId != null) {
          controller.updateMessageStatusUI(msg.localId, "sending");

          final response = await chatService.sendMessageToServer(msg);
          if (response != null && response['success'] == true) {
            await localRepo.markAsSynced(msg.localId!, response['server_id']?.toString() ?? '');
            controller.updateMessageStatusUI(msg.localId, "sent");
          } else {
            controller.updateMessageStatusUI(msg.localId, "offline");
          }
        }
      }
    } catch (e) {
      print("Error syncing offline messages: $e");
    }
  }

  Future<void> markServerRead() async {
    try {
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/chat/read_messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": controller.customerId,
          "user_type": "customer",
          "reader_type": "customer",
        }),
      );
    } catch (e) {
      print("Error marking as read: $e");
    }
  }
}
