
import 'package:final_thesis_app/app/typedefs/e_chat_type.dart';
import 'package:final_thesis_app/app/typedefs/entity.dart';
import 'package:final_thesis_app/data/domain/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../configurations/firebase/firebase_access_fields.dart';

part 'chat.g.dart';

class Chat extends Entity {
  String name;
  List<String> participants;
  final EChatType type;
  String fastSearchKey;
  Id? lastMessage;

  Chat ({
    super.id,
    required this.name,
    required this.participants,
    required this.type,
    required this.fastSearchKey,
    this.lastMessage,
    super.createdAt,
    super.updatedAt,
  });

  @override
  String toString() {
    return '\nChat:\n'
      'id: $id\n'
      'name: $name\n'
      'participants: $participants\n'
      'fastSearchKey: $fastSearchKey\n'
      'type: $type\n'
      'lastMessage: $lastMessage\n';
  }
}

@JsonSerializable()
class ChatPayload {
  @JsonKey(name: FirebaseFields.id)
  final Id? id;
  @JsonKey(name: FirebaseFields.chatName)
  final String? name;
  @JsonKey(name: FirebaseFields.participants)
  final List<String>? participants;
  @JsonKey(name: FirebaseFields.chatType)
  final EChatType? type;
  @JsonKey(name: FirebaseFields.fastSearchKey)
  final String? fastSearchKey;
  @JsonKey(name: FirebaseFields.lastMessage)
  final Id? lastMessage;
  @JsonKey(name: FirebaseFields.createdAt)
  final DateTime? createdAt;
  @JsonKey(name: FirebaseFields.updatedAt)
  final DateTime? updatedAt;

  ChatPayload({
    this.id,
    this.name,
    this.participants,
    this.type,
    this.fastSearchKey,
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  ChatPayload chatToChatPayload(Chat chat) {
    return ChatPayload(
      id: chat.id,
      name: chat.name,
      participants: chat.participants,
      type: chat.type,
      fastSearchKey: chat.fastSearchKey,
      lastMessage: chat.lastMessage,
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
    );
  }

  Chat? chatFromPayload(){
    return Chat(
      id: id,
      name: name!,
      participants: participants!,
      type: type ?? EChatType.direct,
      fastSearchKey: fastSearchKey!,
      lastMessage: lastMessage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ChatPayload copyWith({
    Id? id,
    String? name,
    List<String>? participants,
    EChatType? type,
    String? fastSearchKey,
    Id? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatPayload(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      type: type ?? this.type,
      fastSearchKey: fastSearchKey ?? this.fastSearchKey,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ChatPayload.fromJson(Map<String, dynamic> json) =>
      _$ChatPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPayloadToJson(this);

  @override
  String toString() {
    return '\nChatPayload:\n'
      'id: $id\n'
      'name: $name\n'
      'participants: $participants\n'
      'type: $type\n'
      'fastSearchKey: $fastSearchKey\n'
      'lastMessage: $lastMessage\n'
      'createdAt: $createdAt\n'
      'updatedAt: $updatedAt\n';
  }
}