import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:final_thesis_app/data/domain/chat.dart';
import 'package:final_thesis_app/data/repositories/message/message_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../app/typedefs/entity.dart';
import '../repository.dart';

class ChatStorage extends Repository<FirebaseFirestore> {
  final MessageStorage _messageStorage;
  ChatStorage(this._messageStorage) : super(FirebaseFirestore.instance);

  Future<bool> saveOrUpdateChat(ChatPayload payload) async {
    try {
      final Id id = payload.id ?? Uuid().v4();

      final chatRef = base
          .collection(FirebaseCollectionNames.chats)
          .doc(id);

      final updatedData = <String, Object?>{};
      final newPayload = payload.copyWith(id: id);

      newPayload.toJson().entries.where((entry) => entry.value != null).forEach((entry) {
        final firebaseField = FirebaseFields.mapFirebaseField(entry.key);
        updatedData[firebaseField] = entry.value as Object;
      });

      await chatRef.set(updatedData, SetOptions(merge: true));
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<List<ChatPayload>?> getAllChats() async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.chats)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      return querySnapshot.docs.map((doc) => ChatPayload.fromJson(doc.data())).toList();
    } catch (error) {
      log("Cannot get chats! Error $error");
      return null;
    }
  }

  Future<ChatPayload?> getChatById(Id id) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.chats)
          .where(FirebaseFields.id, isEqualTo: id)
          .limit(1)
          .get();

      return ChatPayload.fromJson(querySnapshot.docs.first.data());
    }catch (error) {
      log("Cannot get chat by id! Error $error");
      return null;
    }
  }

  Future<List<ChatPayload>?> getChatsByUserId(Id userId) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.chats)
          .where(FirebaseFields.participants, arrayContains: userId)
          .orderBy(FirebaseFields.updatedAt, descending: true)
          .get();

      return querySnapshot.docs.map((doc) => ChatPayload.fromJson(doc.data())).toList();
    }catch (error) {
      log("Cannot get events by user id! Error $error");
      return null;
    }
  }

  Future<ChatPayload?> getDirectChat(Id firstUserId, Id secondUserId) async {
    try {
      final users = List.of([firstUserId, secondUserId])..sort((a, b) => a.compareTo(b));
      final fastSearchKey = users.join("_");

      final querySnapshot = await base
          .collection(FirebaseCollectionNames.chats)
          .where(FirebaseFields.fastSearchKey, isEqualTo: fastSearchKey)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty ? ChatPayload.fromJson(querySnapshot.docs.first.data()) : null;
    } catch (error) {
      log("Cannot get direct chat! Error $error");
      return null;
    }
  }

  Future<bool> deleteChat(ChatPayload payload) async {
    try {
      final chatRef = base
          .collection(FirebaseCollectionNames.chats)
          .doc(payload.id);

      final result = await _messageStorage.deleteAllMessagesByChatId(payload.id!);
      if (!result) {
        log("Failed to delete messages for chat ${payload.id}");
        return false;
      }

      await chatRef.delete();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteChatById(Id id) async {
    try {
      final chat = base
          .collection(FirebaseCollectionNames.chats)
          .doc(id);

      final result = await _messageStorage.deleteAllMessagesByChatId(id);
      if (!result) {
        log("Failed to delete messages for chat $id");
        return false;
      }

      await chat.delete();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}