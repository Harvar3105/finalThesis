

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../data/domain/event.dart';
import '../../../data/domain/user.dart';

part 'event_view_model.g.dart';

@riverpod
class EventViewModel extends _$EventViewModel {
  @override
  Future<(User?, User?)?> build(Event event) async {
    try {
      final userService = ref.watch(userServiceProvider);
      final currentUser = await userService.getCurrentUser();
      User? otherUser;
      if (event.friendId != null) {
        otherUser = await userService.getUserById(event.friendId!);
      }

      if (currentUser == null) {
        state = AsyncValue.error("User not found", StackTrace.current);
      }

      return (currentUser, otherUser);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }

  Future<bool> deleteEvent(Event event) async {
    final eventService = ref.read(eventServiceProvider);
    final result = await eventService.deleteEvent(event);
    if (!result){
      state = AsyncValue.error("Failed to delete event", StackTrace.current);
      return false;
    } else {
      return true;
    }
  }
}
