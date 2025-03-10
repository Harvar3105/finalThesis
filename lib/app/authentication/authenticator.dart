import 'package:final_thesis_app/app/typedefs/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/auth_result.dart';

class Authenticator {
  const Authenticator();

  bool get isAlreadyLoggedIn => userId != null;

  Id? get userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<AuthResult> loginWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return AuthResult.tooManyAttemptsTryAgainLater;
      } else {
        return AuthResult.failure;
      }
    } catch (e) {
      return AuthResult.failure;
    }
  }

  Future<AuthResult> registerWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return AuthResult.userAlreadyExists;
      } else if (e.code == 'too-many-requests') {
        return AuthResult.tooManyAttemptsTryAgainLater;
      }
      return AuthResult.failure;
    } catch (e) {
      return AuthResult.failure;
    }
  }

  Future<AuthResult> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return AuthResult.failure;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return AuthResult.tooManyAttemptsTryAgainLater;
      } else {
        return AuthResult.failure;
      }
    } catch (e) {
      return AuthResult.failure;
    }
  }

  Future<AuthResult> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return AuthResult.failure;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(newEmail);

      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return AuthResult.userAlreadyExists;
      } else if (e.code == 'too-many-requests') {
        return AuthResult.tooManyAttemptsTryAgainLater;
      } else {
        return AuthResult.failure;
      }
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
