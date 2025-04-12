import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/typedefs/entity.dart';
import '../../configurations/firebase/firebase_access_fields.dart';
import 'entity.dart';

part 'message.g.dart';

class Message extends Entity {
  final String text;
  final Id senderId;
  final Id chatId;

  Message({
    super.id,
    required this.text,
    required this.senderId,
    required this.chatId,
    super.createdAt,
    super.updatedAt,
  });

  @override
  String toString() {
    return '\nMessage:\n'
      'id: $id\n'
      'text: $text\n'
      'senderId: $senderId\n'
      'chatId: $chatId\n'
      'createdAt: $createdAt\n'
      'updatedAt: $updatedAt\n';
  }
}

@JsonSerializable()
class MessagePayload {
  @JsonKey(name: FirebaseFields.id)
  final Id? id;
  @JsonKey(name: FirebaseFields.text)
  final String? text;
  @JsonKey(name: FirebaseFields.senderId)
  final Id? senderId;
  @JsonKey(name: FirebaseFields.chatId)
  final Id? chatId;
  @JsonKey(name: FirebaseFields.createdAt)
  final DateTime? createdAt;
  @JsonKey(name: FirebaseFields.updatedAt)
  final DateTime? updatedAt;

  MessagePayload({
    this.id,
    this.text,
    this.senderId,
    this.chatId,
    this.createdAt,
    this.updatedAt,
  });

  MessagePayload messageToMessagePayload(Message message) {
    return MessagePayload(
      id: message.id,
      text: message.text,
      senderId: message.senderId,
      chatId: message.chatId,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
    );
  }

  Message? messageFromPayload(){
    return Message(
      id: id,
      text: text!,
      senderId: senderId!,
      chatId: chatId!,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  MessagePayload copyWith({
    Id? id,
    String? text,
    Id? senderId,
    Id? chatId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessagePayload(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MessagePayload.fromJson(Map<String, dynamic> json) =>
      _$MessagePayloadFromJson(json);

  Map<String, dynamic> toJson() => _$MessagePayloadToJson(this);

  @override
  String toString() {
    return '\nMessagePayload:\n'
      'id: $id\n'
      'text: $text\n'
      'senderId: $senderId\n'
      'chatId: $chatId\n'
      'createdAt: $createdAt\n'
      'updatedAt: $updatedAt\n';
  }
}