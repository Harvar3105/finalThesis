import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/domain/user.dart';
import '../authentication/authenticator.dart';
import '../repository.dart';
import '../user/user_storage.dart';

class PushNotifications extends Repository<FirebaseMessaging> {
  final Authenticator _authenticator;
  final UserStorage _userStorage;
  PushNotifications(this._authenticator, this._userStorage) : super(FirebaseMessaging.instance);

  Future<String?> getFcmToken() async {
    return await base.getToken();
  }

  Future<void> initialize() async {
    final id = _authenticator.id;

    try {
      final permission = await base.requestPermission();
      if (permission.authorizationStatus == AuthorizationStatus.denied) {
        log('User denied push notification permissions.');
        return;
      }

      final token = await getFcmToken();
      if (token != null && id != null) {
        final userPayload = UserPayload(id: id, fcmToken: token);

        await _userStorage.saveOrUpdateUserInfo(userPayload);

        base.onTokenRefresh.listen((newToken) async {
          await _userStorage.saveOrUpdateUserInfo(userPayload);
        });

        // Handle here all the business logic related to push notifications
        final initialMessage = await base.getInitialMessage();

        if (initialMessage != null) {
          _handleMessage(initialMessage, 'App opened from TERMINATED state');
        }

        FirebaseMessaging.onMessage.listen((message) {
          _handleMessage(message, 'Notification received in FOREGROUND');
        });

        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          _handleMessage(message, 'App opened from BACKGROUND');
        });
      }
    } catch (e) {
      log('Error initializing push notifications: $e');
    }
  }

  // Logging
  void _handleMessage(RemoteMessage message, String context) async {
    log('[$context]');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    log('Data: ${message.data}');
  }
}
