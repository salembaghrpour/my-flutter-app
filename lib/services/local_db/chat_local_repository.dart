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

  // اضافه شدن پارامترهای limit و offset
  Future<List<ChatMessageLocal>> getMessagesByConversation(String conversationId, {int limit = 20, int offset = 0}) async {
    final box = await _getBox();
    var messages = box.values
        .where((msg) => msg.conversationId == conversationId)
        .toList();
        
    // ابتدا مرتب‌سازی نزولی (جدیدترین به قدیمی‌ترین) برای اعمال صحیح صفحه‌بندی و اسکیپ کردن
    messages.sort((a, b) {
      DateTime dtA = DateTime.tryParse(a.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      DateTime dtB = DateTime.tryParse(b.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dtB.compareTo(dtA);
    });

    // اعمال Pagination
    messages = messages.skip(offset).take(limit).toList();

    // مرتب‌سازی مجدد به صورت صعودی (قدیمی‌ترین به جدیدترین) برای نمایش صحیح
    messages.sort((a, b) {
      DateTime dtA = DateTime.tryParse(a.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      DateTime dtB = DateTime.tryParse(b.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dtA.compareTo(dtB);
    });

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
