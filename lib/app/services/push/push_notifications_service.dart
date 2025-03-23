import 'package:final_thesis_app/data/repositories/push/push_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/providers.dart';

class PushNotificationsService {
  final PushNotifications _pushNotifications;

  PushNotificationsService(this._pushNotifications) {
    _pushNotifications.initialize();
  }


  Future<String?> getFcmToken() async {
    return await _pushNotifications.getFcmToken();
  }
}