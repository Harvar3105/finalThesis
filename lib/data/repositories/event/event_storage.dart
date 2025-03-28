import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/data/domain/event.dart';
import 'package:uuid/uuid.dart';

import '../../../app/typedefs/entity.dart';
import '../../../configurations/firebase/firebase_access_fields.dart';
import '../repository.dart';

class EventStorage extends Repository<FirebaseFirestore> {

  EventStorage() : super(FirebaseFirestore.instance);

  Future<bool> saveOrUpdateEvent(EventPayload payload) async {
    try {
      final Id id = payload.id ?? Uuid().v4();

      final eventRef = base
          .collection('events')
          .doc(id);

      final updatedData = <String, Object?>{};
      final newPayload = payload.copyWith(id: id);

      newPayload.toJson().entries.where((entry) => entry.value != null).forEach((entry) {
        final firebaseField = FirebaseFields.mapFirebaseField(entry.key);
        updatedData[firebaseField] = entry.value as Object;
      });

      await eventRef.set(updatedData, SetOptions(merge: true));
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<List<EventPayload>?> getAllEvents() async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.events)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      return querySnapshot.docs.map((doc) => EventPayload.fromJson(doc.data())).toList();
    }catch (error) {
      log("Cannot get all events! Error $error");
      return null;
    }
  }

  Future<EventPayload?> getEventById(Id id) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.id, isEqualTo: id)
          .limit(1)
          .get();

      return EventPayload.fromJson(querySnapshot.docs.first.data());
    }catch (error) {
      log("Cannot get event by id! Error $error");
      return null;
    }
  }

  Future<List<EventPayload>?> getEventsByUserId(Id userId, isCoach) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.events)
          .where(isCoach ? FirebaseFields.coachId : FirebaseFields.athleteId, isEqualTo: userId)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      return querySnapshot.docs.map((doc) => EventPayload.fromJson(doc.data())).toList();
    }catch (error) {
      log("Cannot get events by user id! Error $error");
      return null;
    }
  }

  Future<bool> deleteEvent(EventPayload payload) async {
    try {
      final eventRef = base
          .collection(FirebaseCollectionNames.events)
          .doc(payload.id);

      await eventRef.delete();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}