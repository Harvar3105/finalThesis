import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/app/typedefs/e_event_type.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:final_thesis_app/data/domain/event.dart';
import 'package:final_thesis_app/data/repositories/event/event_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../generators/event_generator.dart';
import '../../mocks/firebase.dart';


void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late EventStorage eventStorage;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);

    eventStorage = EventStorage(mockFirestore);
  });

  group('EventStorage', () {
    test('saveOrUpdateEvent should save event and return true', () async {
      final event = generateRandomEvent(true);
      final payload = EventPayload().eventToPayload(event);

      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async => {});

      final result = await eventStorage.saveOrUpdateEvent(payload);

      expect(result, true);
      verify(() => mockDocRef.set(any(), any())).called(1);
    });

    test('deleteEvent should delete event and return true', () async {
      final event = generateRandomEvent(false);
      final payload = EventPayload().eventToPayload(event);

      when(() => mockDocRef.delete()).thenAnswer((_) async => {});
      when(() => mockCollection.doc(payload.id)).thenReturn(mockDocRef);

      final result = await eventStorage.deleteEvent(payload);

      expect(result, true);
      verify(() => mockDocRef.delete()).called(1);
    });

    test('getAllEvents should return list of events', () async {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();
      final event = generateRandomEvent(false);
      final data = EventPayload().eventToPayload(event).toJson();

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.orderBy(any(), descending: any(named: 'descending')))
          .thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn([mockDoc]);
      when(() => mockDoc.data()).thenReturn(data);

      final result = await eventStorage.getAllEvents();

      expect(result, isA<List<EventPayload>>());
      expect(result!.length, 1);
    });

    test('getProcessedEventCountByUserPair returns correct count', () async {
      final mockCollection = MockCollectionReference();

      final mockQuery1 = MockQuery();
      final mockQuery2 = MockQuery();

      final mockFilteredQuery1_1 = MockQuery();
      final mockFilteredQuery1_2 = MockQuery();

      final mockFilteredQuery2_1 = MockQuery();
      final mockFilteredQuery2_2 = MockQuery();

      final mockAggregateQuery1 = MockAggregateQuery();
      final mockAggregateQuery2 = MockAggregateQuery();

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

      when(() => mockCollection.where(FirebaseFields.creatorId, isEqualTo: 'user1'))
          .thenReturn(mockFilteredQuery1_1);
      when(() => mockFilteredQuery1_1.where(FirebaseFields.friendId, isEqualTo: 'user2'))
          .thenReturn(mockFilteredQuery1_2);
      when(() => mockFilteredQuery1_2.where(FirebaseFields.type, isEqualTo: EEventType.processed.name))
          .thenReturn(mockQuery1);

      when(() => mockCollection.where(FirebaseFields.creatorId, isEqualTo: 'user2'))
          .thenReturn(mockFilteredQuery2_1);
      when(() => mockFilteredQuery2_1.where(FirebaseFields.friendId, isEqualTo: 'user1'))
          .thenReturn(mockFilteredQuery2_2);
      when(() => mockFilteredQuery2_2.where(FirebaseFields.type, isEqualTo: EEventType.processed.name))
          .thenReturn(mockQuery2);

      when(() => mockQuery1.count()).thenReturn(mockAggregateQuery1);
      when(() => mockQuery2.count()).thenReturn(mockAggregateQuery2);

      when(() => mockAggregateQuery1.get()).thenAnswer((_) async => AggregateQuerySnapshotFake(3));
      when(() => mockAggregateQuery2.get()).thenAnswer((_) async => AggregateQuerySnapshotFake(2));

      final result = await eventStorage.getProcessedEventCountByUserPair('user1', 'user2');

      expect(result, 5);
    });


    test('getEventById returns an EventPayload', () async {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();
      final event = generateRandomEvent(false);
      final data = EventPayload().eventToPayload(event).toJson();

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.limit(1)).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn([mockDoc]);
      when(() => mockDoc.data()).thenReturn(data);

      final result = await eventStorage.getEventById(event.id!);

      expect(result, isNotNull);
      expect(result!.id, event.id);
    });
  });
}

