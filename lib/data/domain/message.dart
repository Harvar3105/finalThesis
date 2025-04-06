import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/typedefs/entity.dart';
import 'entity.dart';

class Message extends Entity {
  final String text;
  final Id senderId;
  final Id receiverId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  Message({
    super.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return '\nMessage:\n'
        'id: $id\n'
        'text: $text\n'
        'senderId: $senderId\n'
        'receiverId: $receiverId\n'
        'createdAt: $createdAt\n'
        'updatedAt: $updatedAt\n';
  }
}

@JsonSerializable()
class MessagePayload {
  //TODO: Implement messages class

  final Id? id;
  final String? text;
  final Id? senderId;
  final Id? receiverId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessagePayload({
    this.id,
    this.text,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return '\nMessagePayload:\n'
        'id: $id\n'
        'text: $text\n'
        'senderId: $senderId\n'
        'receiverId: $receiverId\n'
        'createdAt: $createdAt\n'
        'updatedAt: $updatedAt\n';
  }
}