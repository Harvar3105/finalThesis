import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/providers.dart';

part 'push_notifications_service.g.dart';

@riverpod
class PushNotificationsService extends _$PushNotificationsService {
  @override
  Future<void> build() async {
    initialize();
  }

  Future<void> initialize() async {
    final pushNotifications = ref.watch(pushNotificationsProvider);
    await pushNotifications.initialize();
  }

  Future<String?> getFcmToken() async {
    final pushNotifications = ref.watch(pushNotificationsProvider);
    return await pushNotifications.getFcmToken();
  }
}