import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockAuthCredential extends Mock implements AuthCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}
class MockUploadTask extends Mock implements UploadTask {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockWriteBatch extends Mock implements WriteBatch {}
class MockSetOptions extends Fake implements SetOptions {}
class MockAggregateQuery extends Mock implements AggregateQuery {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
// class AggregateQuerySnapshotFake extends Fake implements AggregateQuerySnapshot {
//   final int count;
//   AggregateQuerySnapshotFake(this.count);
// }


class AggregateQuerySnapshotFake implements AggregateQuerySnapshot {
  @override
  final int count;

  AggregateQuerySnapshotFake(this.count);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}