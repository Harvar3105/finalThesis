
import 'package:final_thesis_app/data/repositories/authentication/authenticator.dart';
import 'package:final_thesis_app/data/repositories/image/image_storage.dart';
import 'package:final_thesis_app/data/repositories/push/push_notifications.dart';
import 'package:final_thesis_app/data/repositories/user/user_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStorageProvider = Provider<UserStorage>((ref) {
  return UserStorage(ref.watch(authenticationProvider));
});

final imageStorageProvider = Provider<ImageStorage>((ref) {
  return ImageStorage();
});

final authenticationProvider = Provider<Authenticator>((ref) {
  return Authenticator();
});

final pushNotificationsProvider = Provider<PushNotifications>((ref) {
  return PushNotifications(ref.watch(authenticationProvider), ref.watch(userStorageProvider));
});