// D:\accounting_Arya\mobile_app\customer_app\lib\models\local\chat_message_local.dart
import 'package:hive_ce/hive_ce.dart';

part 'chat_message_local.g.dart'; 

@HiveType(typeId: 0)
class ChatMessageLocal extends HiveObject {
  @HiveField(0) int? localId;
  @HiveField(1) String? serverId;
  @HiveField(2) String conversationId;
  @HiveField(3) String senderType;
  @HiveField(4) String content;
  @HiveField(5) String createdAt;
  @HiveField(6) bool isSynced;
  @HiveField(7) bool isRead;
  @HiveField(8) String? clientTempId;
  // --- فیلدهای جدید ---
  @HiveField(9) String messageType; // 'text' یا 'image'
  @HiveField(10) String? fileUrl;
  @HiveField(11) int? replyToId;

  ChatMessageLocal({
    this.localId,
    this.serverId,
    required this.conversationId,
    required this.senderType,
    required this.content,
    required this.createdAt,
    this.isSynced = false,
    this.isRead = false,
    this.clientTempId,
    this.messageType = 'text',
    this.fileUrl,
    this.replyToId,
  });

  ChatMessageLocal copyWith({
    int? localId, String? serverId, String? conversationId, String? senderType,
    String? content, String? createdAt, bool? isSynced, bool? isRead,
    String? clientTempId, String? messageType, String? fileUrl, int? replyToId,
  }) {
    return ChatMessageLocal(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      conversationId: conversationId ?? this.conversationId,
      senderType: senderType ?? this.senderType,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      isRead: isRead ?? this.isRead,
      clientTempId: clientTempId ?? this.clientTempId,
      messageType: messageType ?? this.messageType,
      fileUrl: fileUrl ?? this.fileUrl,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}
