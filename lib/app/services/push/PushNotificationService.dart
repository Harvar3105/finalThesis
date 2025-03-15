import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/domain/user.dart';
import '../authentication/authenticator.dart';
import '../../storage/user/user_strorage.dart';

class PushNotificationService {
  static final PushNotificationService _instance =
  PushNotificationService._internal();

  factory PushNotificationService() => _instance;

  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Authenticator _authenticator = const Authenticator();
  final UserStorage _userStorage = const UserStorage();

  Future<String?> getFcmToken() async => await _firebaseMessaging.getToken();

  Future<void> initialize() async {
    final id = _authenticator.id;

    try {
      final permission = await _firebaseMessaging.requestPermission();
      if (permission.authorizationStatus == AuthorizationStatus.denied) {
        log('User denied push notification permissions.');
        return;
      }

      final token = await getFcmToken();
      if (token != null && id != null) {
        final userPayload = UserPayload(id: id, fcmToken: token);

        await _userStorage.saveOrUpdateUserInfo(userPayload);

        _firebaseMessaging.onTokenRefresh.listen((newToken) async {
          await _userStorage.saveOrUpdateUserInfo(userPayload);
        });

        // Handle here all the business logic related to push notifications
        final initialMessage = await _firebaseMessaging.getInitialMessage();

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
