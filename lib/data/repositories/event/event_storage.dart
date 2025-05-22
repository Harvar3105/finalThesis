import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/app/typedefs/e_event_type.dart';
import 'package:final_thesis_app/data/domain/event.dart';
import 'package:uuid/uuid.dart';

import '../../../app/typedefs/entity.dart';
import '../../../configurations/firebase/firebase_access_fields.dart';
import '../repository.dart';

class EventStorage extends Repository<FirebaseFirestore> {

  EventStorage([FirebaseFirestore? mock]) : super(mock ?? FirebaseFirestore.instance);

  Future<bool> saveOrUpdateEvent(EventPayload payload) async {
    try {
      final Id id = payload.id ?? Uuid().v4();

      final eventRef = base
          .collection(FirebaseCollectionNames.events)
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

  Future<List<EventPayload>?> getProcessedEventsByUserId(Id userId) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.creatorId, isEqualTo: userId)
          .where(FirebaseFields.type, isEqualTo: EEventType.processed.name)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      return querySnapshot.docs.map((doc) => EventPayload.fromJson(doc.data())).toList();
    }catch (error) {
      log("Cannot get processed events by user id! Error $error");
      return null;
    }
  }

  Future<List<EventPayload>?> getProcessedEventsByUserAndFriendIds(Id user1Id, Id user2Id) async {
    try {
      final query1 = base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.creatorId, isEqualTo: user1Id)
          .where(FirebaseFields.friendId, isEqualTo: user2Id)
          .where(FirebaseFields.type, isEqualTo: EEventType.processed.name)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      final query2 = base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.creatorId, isEqualTo: user2Id)
          .where(FirebaseFields.friendId, isEqualTo: user1Id)
          .where(FirebaseFields.type, isEqualTo: EEventType.processed.name)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      final snapshots = await Future.wait([query1, query2]);
      final combined = <EventPayload>[];
      for (final snapshot in snapshots) {
        combined.addAll(snapshot.docs.map((doc) => EventPayload.fromJson(doc.data())));
      }

      return combined;
    }catch (error) {
      log("Cannot get processed events by user and friend ids! Error $error");
      return null;
    }
  }

  Future<int> getProcessedEventCountByUserPair(Id user1Id, Id user2Id) async {
    try {
      final collection = base.collection(FirebaseCollectionNames.events);

      final query1 = collection
          .where(FirebaseFields.creatorId, isEqualTo: user1Id)
          .where(FirebaseFields.friendId, isEqualTo: user2Id)
          .where(FirebaseFields.type, isEqualTo: EEventType.processed.name);

      final query2 = collection
          .where(FirebaseFields.creatorId, isEqualTo: user2Id)
          .where(FirebaseFields.friendId, isEqualTo: user1Id)
          .where(FirebaseFields.type, isEqualTo: EEventType.processed.name);

      final countResults = await Future.wait([
        query1.count().get(),
        query2.count().get(),
      ]);

      final count1 = countResults[0].count;
      final count2 = countResults[1].count;

      return count1! + count2!;
    } catch (error) {
      log("Failed to count processed events for user pair: $error");
      return 0;
    }
  }

  Future<List<EventPayload>?> getEventsByDate(DateTime date) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.start, isLessThanOrEqualTo: date)
          .where(FirebaseFields.end, isGreaterThanOrEqualTo: date)
          .get();

      return querySnapshot.docs.map((doc) => EventPayload.fromJson(doc.data())).toList();
    }catch (error) {
      log("Cannot get events by date! Error $error");
      return null;
    }
  }

  Future<EventPayload?> getEventCounterOffer(Id originalEventId) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.counterOfferOf, isEqualTo: originalEventId)
          .limit(1)
          .get();

      return EventPayload.fromJson(querySnapshot.docs.first.data());
    }catch (error) {
      log("Cannot get event counter offer! Error $error");
      return null;
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

  Future<List<EventPayload>?> getEventsByUserId(Id userId) async {
    try {
      final firstQuery = base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.creatorId, isEqualTo: userId)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      final secondQuery = base
          .collection(FirebaseCollectionNames.events)
          .where(FirebaseFields.friendId, isEqualTo: userId)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();

      final results = await Future.wait([firstQuery, secondQuery]);
      final allDocuments = results.expand((snapshot) => snapshot.docs).toList();

      return allDocuments.map((doc) => EventPayload.fromJson(doc.data())).toList();
    }catch (error) {
      log("Cannot get events by user id! Error $error");
      return null;
    }
  }

  Future<bool> deleteEvent(EventPayload payload) async {
    log("Deleting event with id: ${payload.id}");
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

  // Unfortunately, Dart does not support method overloading
  Future<bool> deleteEventById(Id id) async {
    try {
      final eventRef = base
          .collection(FirebaseCollectionNames.events)
          .doc(id);

      await eventRef.delete();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}