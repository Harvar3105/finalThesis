import 'package:final_thesis_app/data/repositories/push/push_notifications.dart';

import '../../../data/domain/user.dart';

class PushNotificationsService {
  final PushNotifications _pushNotifications;

  PushNotificationsService(this._pushNotifications) {
    _pushNotifications.initialize();
  }

  Future<bool> pushNotification(User toUser, String title, String message) async {
    if (toUser.fcmToken == null) {
      return false;
    }

    return await _pushNotifications.sendNotification(toUser.fcmToken!, title, message);
  }


  Future<String?> getFcmToken() async {
    return await _pushNotifications.getFcmToken();
  }
}