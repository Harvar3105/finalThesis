
import 'dart:async';
import 'dart:developer';

import 'package:final_thesis_app/app/typedefs/e_event_type.dart';
import 'package:final_thesis_app/data/domain/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../app/typedefs/e_role.dart';
import '../../../data/domain/user.dart';

part 'day_view_model.g.dart';

@riverpod
class DayViewModel extends _$DayViewModel {
  @override
  Future<List<Event>?> build({User? user}) async {
    final eventsService = ref.watch(eventServiceProvider);
    var currentUser = user;
    if (user == null) {
      final userService = ref.read(userServiceProvider);
      currentUser = await userService.getCurrentUser();
    }

    if (currentUser == null) {
      state = AsyncValue.error("Current user not found", StackTrace.current);
      return [];
    }

    final events = await eventsService.getEventsByUserId(currentUser.id!, currentUser.role == ERole.coach);
    log(events.toString());
    return events;
  }

  bool checkEventOverlap(Event event) {
    if (event.type == EEventType.shadow) {
      return false; // No overlap check for shadow events
    }

    final events = state.value;
    if (events == null) {
      return false;
    }

    for (var e in events) {
      if (e.id != event.id &&
          e.type != EEventType.shadow &&
          e.start.isBefore(event.end) &&
          e.end.isAfter(event.start)
      ) {
        return true; // Overlap found
      }
    }
    return false; // No overlap
  }
}