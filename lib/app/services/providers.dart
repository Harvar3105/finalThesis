import 'package:final_thesis_app/app/services/image/image_service.dart';
import 'package:final_thesis_app/app/services/push/push_notifications_service.dart';
import 'package:final_thesis_app/app/services/user/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'event/event_service.dart';
import 'mixed_services/friendship_service.dart';


final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref.watch(userStorageProvider), ref.watch(imageServiceProvider));
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService(ref.watch(imageStorageProvider));
});

final pushNotificationsServiceProvider = Provider<PushNotificationsService>((ref) {
  return PushNotificationsService(ref.watch(pushNotificationsProvider));
});

final friendshipServiceProvider = Provider<FriendshipService>((ref) {
  return FriendshipService(ref.watch(userServiceProvider), ref.watch(pushNotificationsServiceProvider));
});

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService(ref.watch(eventStorageProvider), ref.watch(userServiceProvider));
});

