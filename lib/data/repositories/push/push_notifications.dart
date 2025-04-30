import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:final_thesis_app/app/typedefs/e_event_type.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_api_keys.dart';
import 'package:final_thesis_app/data/repositories/event/event_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../repository.dart';
import '../user/user_storage.dart';

import 'package:final_thesis_app/app/helpers/push_notifications_initialization/platform_export.dart';

class PushNotifications extends Repository<FirebaseMessaging> {
  final UserStorage _userStorage;
  final EventStorage _eventStorage;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  PushNotifications(this._userStorage, this._eventStorage) : super(FirebaseMessaging.instance);

  Future<String?> getFcmToken() async {
    return await base.getToken();
  }

  Future<String> getAccessToken() async {
    final jsonCredentials = File('assets/service-account.json').readAsStringSync();

    final credentials = ServiceAccountCredentials.fromJson(jsonCredentials);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(credentials, scopes);
    return client.credentials.accessToken.data;
  }

  Future<void> initialize() async {
    final id = _userStorage.getCurrentUserId();
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
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          final actionId = response.actionId;
          final eventId = response.payload;
          final event = await _eventStorage.getEventById(eventId!);

          if (event == null) {
            log('Event not found for ID: $eventId');
            return;
          }
          if (event.type == EEventType.processed || event.type == EEventType.canceled) {
            return;
          }

          if (actionId == 'yes') {
            log('✅ ');
            event.copyWith(type: EEventType.processed);
          } else if (actionId == 'no') {
            log('❌ ');
            event.copyWith(type: EEventType.canceled);
          }
          // else {
          //   _showConfirmationNotification(
          //     title: 'Did event happened?',
          //     body: 'Did event happened?!',
          //   );
          // }
          await _eventStorage.saveOrUpdateEvent(event);
        },
      );

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final data = message.data;

        final eventId = data['eventId'];
        final title = data['title'] ?? 'Did event happen?';
        final body = data['body'] ?? 'Please confirm.';

        _showConfirmationNotification(
          title: title,
          body: body,
          eventId: eventId
        );
      });

    } catch (e) {
      log('Error initializing push notifications: $e');
    }
  }

  Future<void> _showConfirmationNotification({
    required String title,
    required String body,
    required String? eventId,
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
      payload: eventId,
    );
  }

  Future<bool> sendNotification(String fcmToken, String title, String body) async {
    try {
      final url = Uri.parse(FirebaseApiKeys.getFCMLink());
      final accessToken = await getAccessToken();

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
        'Authorization': 'Bearer $accessToken',
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
