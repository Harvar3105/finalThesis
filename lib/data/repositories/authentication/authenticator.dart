import 'package:final_thesis_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/typedefs/entity.dart';
import '../../../presentation/view_models/authentication/models/e_authentication_result.dart';
import '../repository.dart';

class Authenticator extends Repository<FirebaseAuth> {
  Authenticator([FirebaseAuth? mock]) : super(mock ?? FirebaseAuth.instance);

  bool get isAlreadyLoggedIn => id != null;

  Id? get id => base.currentUser?.uid;

  Future<void> logOut() async {
    await base.signOut();
  }

  Future<EAuthenticationResult> loginWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      await base.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return EAuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return EAuthenticationResult.tooManyAttemptsTryAgainLater;
      } else {
        return EAuthenticationResult.failure;
      }
    } catch (e) {
      return EAuthenticationResult.failure;
    }
  }

  Future<EAuthenticationResult> registerWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      await base.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return EAuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return EAuthenticationResult.userAlreadyExists;
      } else if (e.code == 'too-many-requests') {
        return EAuthenticationResult.tooManyAttemptsTryAgainLater;
      }
      return EAuthenticationResult.failure;
    } catch (e) {
      return EAuthenticationResult.failure;
    }
  }

  Future<EAuthenticationResult> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = base.currentUser;

      if (user == null) {
        return EAuthenticationResult.failure;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      return EAuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return EAuthenticationResult.tooManyAttemptsTryAgainLater;
      } else {
        return EAuthenticationResult.failure;
      }
    } catch (e) {
      return EAuthenticationResult.failure;
    }
  }

  Future<EAuthenticationResult> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    try {
      final user = base.currentUser;

      if (user == null) {
        return EAuthenticationResult.failure;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(newEmail);

      return EAuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return EAuthenticationResult.userAlreadyExists;
      } else if (e.code == 'too-many-requests') {
        return EAuthenticationResult.tooManyAttemptsTryAgainLater;
      } else {
        return EAuthenticationResult.failure;
      }
    } catch (e) {
      return EAuthenticationResult.failure;
    }
  }
}