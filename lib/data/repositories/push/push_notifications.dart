import 'dart:convert';
import 'dart:developer';

import 'package:final_thesis_app/configurations/firebase/firebase_api_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../authentication/authenticator.dart';
import '../repository.dart';
import '../user/user_storage.dart';

import 'package:final_thesis_app/app/helpers/push_notifications_initialization/platform_export.dart';

class PushNotifications extends Repository<FirebaseMessaging> {
  final Authenticator _authenticator;
  final UserStorage _userStorage;

  PushNotifications(this._authenticator, this._userStorage) : super(FirebaseMessaging.instance);

  Future<String?> getFcmToken() async {
    return await base.getToken();
  }

  Future<void> initialize() async {
    final id = _authenticator.id;
    if (id == null) {
      log('User ID is null. Cannot initialize push notifications.');
      return;
    }

    try {
      await platformInit(pn: this, id: id, userStorage: _userStorage);

    } catch (e) {
      log('Error initializing push notifications: $e');
    }
  }

  Future<bool> sendNotification(String fcmToken, String title, String body) async {
    try {
      final url = Uri.parse(FirebaseApiKeys.getFCMLink());

      final message = {
        'to': fcmToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'priority': 'normal',
      };

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${FirebaseApiKeys.serviceAccountAccessToken}',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        log('Notification sent successfully!');
        return true;
      } else {
        log('Failed to send notification: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error sending notification: $e');
      return false;
    }
  }

  void handleMessage(RemoteMessage message, String context) async {
    log('[$context]');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    log('Data: ${message.data}');
  }
}
