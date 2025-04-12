import 'dart:developer';

import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:final_thesis_app/data/repositories/repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../../domain/message.dart';

class MessageStorage extends Repository<FirebaseDatabase> {
  MessageStorage() : super(FirebaseDatabase.instance);

  Future<bool> saveOrUpdateMessage(MessagePayload payload) async {
    try {
      final String messageId = payload.id ?? const Uuid().v4();
      final String chatId = payload.chatId ?? (throw ArgumentError('chatId is required'));

      final messageRef = base.ref().child(FirebaseCollectionNames.messages).child(chatId).child(messageId);

      final newPayload = payload.copyWith(id: messageId);
      final updatedData = <String, Object?>{};

      newPayload.toJson().entries.where((e) => e.value != null).forEach((entry) {
        final firebaseField = FirebaseFields.mapFirebaseField(entry.key);
        updatedData[firebaseField] = entry.value as Object;
      });

      await messageRef.set(updatedData);
      return true;
    } catch (e) {
      log("Failed to save or update message: $e");
      return false;
    }
  }

  Stream<List<MessagePayload>?> listenToChatMessages(String chatId) {
    final chatMessagesRef = base.ref().child(FirebaseCollectionNames.messages).child(chatId);

    return chatMessagesRef
        .orderByChild(FirebaseFields.createdAt)
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      if (data == null) return null;

      final rawMap = Map<String, dynamic>.from(data as Map);
      return rawMap.entries.map((entry) {
        final messageData = Map<String, dynamic>.from(entry.value);
        messageData[FirebaseFields.id] = entry.key;
        return MessagePayload.fromJson(messageData);
      }).toList();
    });
  }

  Future<List<MessagePayload>?> getMessagesByChatId(String chatId) async {
    try {
      final chatMessagesRef = base.ref().child(FirebaseCollectionNames.messages).child(chatId);
      final snapshot = await chatMessagesRef.orderByChild(FirebaseFields.createdAt).once();

      if (snapshot.snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);

      return data.entries.map((entry) {
        final messageData = Map<String, dynamic>.from(entry.value);
        messageData[FirebaseFields.id] = entry.key;
        return MessagePayload.fromJson(messageData);
      }).toList();
    } catch (e) {
      log("Failed to get messages by chatId: $e");
      return null;
    }
  }

  Future<bool> deleteMessage(MessagePayload payload) async {
    try {
      final ref = base.ref().child(FirebaseCollectionNames.messages).child(payload.chatId!).child(payload.id!);
      await ref.remove();
      return true;
    } catch (e) {
      log("Failed to delete message: $e");
      return false;
    }
  }

  Future<bool> deleteMessageByIds(String chatId, String messageId) async {
    try {
      final ref = base.ref().child(FirebaseCollectionNames.messages).child(chatId).child(messageId);
      await ref.remove();
      return true;
    } catch (e) {
      log("Failed to delete message: $e");
      return false;
    }
  }

  Future<bool> deleteAllMessagesByChatId(String chatId) async {
    try {
      final ref = base.ref().child(FirebaseCollectionNames.messages).child(chatId);
      await ref.remove();
      return true;
    } catch (e) {
      log("Failed to delete messages by chatId: $e");
      return false;
    }
  }
}