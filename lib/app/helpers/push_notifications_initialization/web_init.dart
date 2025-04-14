import 'dart:developer';

import 'package:final_thesis_app/data/repositories/push/push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/domain/user.dart';
import '../../../data/repositories/user/user_storage.dart';
import '../../typedefs/entity.dart';
import 'dart:html' as html;

platformInit({required PushNotifications pn, required Id id, required UserStorage userStorage}) async{
  final permission = html.Notification.permission;
  if (permission == 'denied') {
    log('Push notifications are denied! Click lock icon on top of window and enable them.');
    return;
  } else if (permission == 'default') {
    final perm = await pn.base.requestPermission();

    if (perm.authorizationStatus == AuthorizationStatus.denied) {
      log('User have denied push notification permissions.');
      return;
    }
  }

  final token = await pn.getFcmToken();
  if (token != null && id != null) {
    final userPayload = UserPayload(id: id, fcmToken: token);

    await userStorage.saveOrUpdateUserInfo(userPayload);

    pn.base.onTokenRefresh.listen((newToken) async {
      await userStorage.saveOrUpdateUserInfo(userPayload);
    });

    // Handle here all the business logic related to push notifications
    final initialMessage = await pn.base.getInitialMessage();

    if (initialMessage != null) {
      pn.handleMessage(initialMessage, 'App opened from TERMINATED state');
    }

    FirebaseMessaging.onMessage.listen((message) {
      pn.handleMessage(message, 'Notification received in FOREGROUND');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      pn.handleMessage(message, 'App opened from BACKGROUND');
    });
  }
}