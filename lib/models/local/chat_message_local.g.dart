// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageLocalAdapter extends TypeAdapter<ChatMessageLocal> {
  @override
  final int typeId = 0;

  @override
  ChatMessageLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageLocal(
      localId: fields[0] as int?,
      serverId: fields[1] as String?,
      conversationId: fields[2] as String,
      senderType: fields[3] as String,
      content: fields[4] as String,
      createdAt: fields[5] as String,
      isSynced: fields[6] as bool,
      isRead: fields[7] as bool,
      clientTempId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageLocal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.conversationId)
      ..writeByte(3)
      ..write(obj.senderType)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isSynced)
      ..writeByte(7)
      ..write(obj.isRead)
      ..writeByte(8)
      ..write(obj.clientTempId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
