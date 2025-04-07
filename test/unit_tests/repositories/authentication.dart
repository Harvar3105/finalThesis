import 'package:final_thesis_app/data/repositories/authentication/authenticator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../mocks/firebase.dart';


void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late Authenticator authenticator;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();

    authenticator = Authenticator(mockFirebaseAuth);
  });

  test('loginWithEmailAndPassword returns success when no exception thrown', () async {
    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => mockUserCredential);

    final result = await authenticator.loginWithEmailAndPassword('test@email.com', 'password123');

    expect(result.name, equals('success'));
  });

  test('loginWithEmailAndPassword returns tooManyAttemptsTryAgainLater when too-many-requests', () async {
    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenThrow(FirebaseAuthException(code: 'too-many-requests'));

    final result = await authenticator.loginWithEmailAndPassword('test@email.com', 'password123');

    expect(result.name, equals('tooManyAttemptsTryAgainLater'));
  });

  test('logOut calls signOut', () async {
    when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

    await authenticator.logOut();

    verify(() => mockFirebaseAuth.signOut()).called(1);
  });
}