import 'package:final_thesis_app/app/services/image/image_service.dart';
import 'package:final_thesis_app/app/services/push/push_notifications_service.dart';
import 'package:final_thesis_app/app/services/user/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';


final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref.watch(userStorageProvider));
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService(ref.watch(imageStorageProvider));
});

final pushNotificationsServiceProvider = Provider<PushNotificationsService>((ref) {
  return PushNotificationsService(ref.watch(pushNotificationsProvider));
});

