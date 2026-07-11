import 'package:hive/hive.dart';

part 'chat_message_local.g.dart'; // این فایل توسط build_runner تولید می‌شود

@HiveType(typeId: 0)
class ChatMessageLocal extends HiveObject {
  @HiveField(0)
  int? localId;

  @HiveField(1)
  String? serverId;

  @HiveField(2)
  String conversationId;

  @HiveField(3)
  String senderType;

  @HiveField(4)
  String content;

  @HiveField(5)
  String createdAt;

  @HiveField(6)
  bool isSynced;

  @HiveField(7)
  bool isRead;

  ChatMessageLocal({
    this.localId,
    this.serverId,
    required this.conversationId,
    required this.senderType,
    required this.content,
    required this.createdAt,
    this.isSynced = false,
    this.isRead = false,
  });

  ChatMessageLocal copyWith({
    int? localId,
    String? serverId,
    String? conversationId,
    String? senderType,
    String? content,
    String? createdAt,
    bool? isSynced,
    bool? isRead,
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
    );
  }
}
