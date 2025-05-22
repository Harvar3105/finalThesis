

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../data/domain/event.dart';
import '../../../data/domain/user.dart';
import '../calendar/day_view_model.dart';

part 'event_view_model.g.dart';

@riverpod
class EventViewModel extends _$EventViewModel {
  @override
  Future<(User?, User?, User?)?> build(Event event) async {
    try {
      final userService = ref.watch(userServiceProvider);
      final currentUser = await userService.getCurrentUser();
      User? attendee;
      if (event.friendId != null) {
        attendee = await userService.getUserById(event.friendId!);
      }

      if (currentUser == null) {
        state = AsyncValue.error("User not found", StackTrace.current);
      }

      var creator = await userService.getUserById(event.creatorId);
      if (creator == null) {
        state = AsyncValue.error("Creator not found", StackTrace.current);
      }

      return (currentUser, attendee, creator);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }

  Future<bool> makeDecision(Event event, bool isAccept) async {
    final eventService = ref.read(eventServiceProvider);
    final result = await eventService.makeDecision(event, isAccept);

    var currentUser = await ref.read(userServiceProvider).getCurrentUser();
    if (currentUser != null) {
      ref.invalidate(dayViewModelProvider(user: currentUser));
    }

    if (!result){
      state = AsyncValue.error("Failed to make decision", StackTrace.current);
      return false;
    } else {
      return true;
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
