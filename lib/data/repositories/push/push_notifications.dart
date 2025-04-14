import 'dart:convert';
import 'dart:developer';

import 'package:final_thesis_app/configurations/firebase/firebase_api_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

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
      if (kIsWeb) {
        final permission = html.Notification.permission;
        if (permission == 'denied') {
          log('Push notifications are denied! Click lock icon on top of window and enable them.');
        } else if (permission == 'default') {
          final perm = await base.requestPermission();

          if (perm.authorizationStatus == AuthorizationStatus.denied) {
            log('User have denied push notification permissions.');
          }
        }
        return;
      }

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

  void _handleMessage(RemoteMessage message, String context) async {
    log('[$context]');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    log('Data: ${message.data}');
  }
}
