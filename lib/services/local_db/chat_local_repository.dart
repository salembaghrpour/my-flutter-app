// lib/services/local_db/chat_local_repository.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/local/chat_message_local.dart';

class ChatLocalRepository {
  final String boxName = 'pending_chats_box';

  Future<Box<ChatMessageLocal>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<ChatMessageLocal>(boxName);
    }
    return Hive.box<ChatMessageLocal>(boxName);
  }

  Future<int> saveMessage(ChatMessageLocal message) async {
    final box = await _getBox();
    final id = await box.add(message);
    message.localId = id;
    await message.save();
    return id;
  }

  Future<List<ChatMessageLocal>> getMessagesByConversation(String conversationId) async {
    final box = await _getBox();
    final messages = box.values
        .where((msg) => msg.conversationId == conversationId)
        .toList();
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages;
  }

  Future<List<ChatMessageLocal>> getUnsyncedMessages() async {
    final box = await _getBox();
    return box.values.where((msg) => msg.isSynced == false).toList();
  }

  Future<void> markAsSynced(int localId, String serverId) async {
    final box = await _getBox();
    final message = box.get(localId);
    if (message != null) {
      message.isSynced = true;
      message.serverId = serverId;
      await message.save();
    }
  }

  // --- توابع جدید برای مدیریت تیک خوانده شدن ---
  
  // وقتی ادمین پیام‌های مشتری را می‌خواند (تاییدیه از سرور)
  Future<void> markAllCustomerMessagesAsRead(String conversationId) async {
    final box = await _getBox();
    final messages = box.values.where((msg) => msg.conversationId == conversationId && msg.senderType == 'customer');
    for (var msg in messages) {
      if (!msg.isRead) {
        msg.isRead = true;
        await msg.save();
      }
    }
  }

  // وقتی مشتری پیام‌های ادمین را می‌خواند
  Future<void> markAdminMessagesAsRead(String conversationId) async {
    final box = await _getBox();
    final messages = box.values.where((msg) => msg.conversationId == conversationId && msg.senderType == 'admin');
    for (var msg in messages) {
      if (!msg.isRead) {
        msg.isRead = true;
        await msg.save();
      }
    }
  }

  Future<void> deleteMessage(int localId) async {
    final box = await _getBox();
    await box.delete(localId);
  }
}
