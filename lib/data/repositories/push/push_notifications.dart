import 'dart:convert';
import 'dart:developer';

import 'package:final_thesis_app/configurations/firebase/firebase_api_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../authentication/authenticator.dart';
import '../repository.dart';
import '../user/user_storage.dart';

import 'package:final_thesis_app/app/helpers/push_notifications_initialization/platform_export.dart';

class PushNotifications extends Repository<FirebaseMessaging> {
  final Authenticator _authenticator;
  final UserStorage _userStorage;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

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

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'confirm_category',
          actions: [
            DarwinNotificationAction.text('yes', 'YES', buttonTitle: 'YES'),
            DarwinNotificationAction.text('no', 'NO', buttonTitle: 'NO'),
          ],
        ),
      ],
    );

    try {
      await platformInit(pn: this, id: id, userStorage: _userStorage);
      var initSettings = InitializationSettings(
        android: android,
        iOS: ios,
      );

      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          final actionId = response.actionId;
          log("TYPE: ${response.notificationResponseType}");
          log("ACTION: ${response.actionId}");
          log("notification responce recieved");
          if (actionId == 'yes') {
            log('✅ ');
          } else if (actionId == 'no') {
            log('❌ ');
          } else {
            _showConfirmationNotification(
              title: 'Did event happened?',
              body: 'Did event happened?!',
            );
          }
        },
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final data = message.data;
        if (data['type'] == 'confirm') {
          _showConfirmationNotification(
            title: data['title'] ?? 'Did event happened?',
            body: data['body'] ?? 'Did event happened?!',
          );
        }
      });

    } catch (e) {
      log('Error initializing push notifications: $e');
    }
  }

  Future<void> _showConfirmationNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'confirm_channel',
      'confirmation',
      channelDescription: 'channel for confirmation notifications',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'yes',
          'YES',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          'no',
          'NO',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'confirm_category',
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      0,
      title,
      body,
      platformDetails,
    );
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
