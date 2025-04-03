
import 'dart:async';

import 'package:final_thesis_app/data/domain/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../app/typedefs/e_role.dart';

part 'day_view_model.g.dart';

@riverpod
class DayViewModel extends _$DayViewModel {
  @override
  Future<List<Event>?> build() async {
    final correspondingEvents = ref.read(eventServiceProvider);
    final userService = ref.read(userServiceProvider);
    final currentUser = await userService.getCurrentUser();
    if (currentUser == null) {
      state = AsyncValue.error("Current user not found", StackTrace.current);
      return [];
    }

    final events = correspondingEvents.getEventsByUserId(currentUser.id!, currentUser.role == ERole.coach);

    return events;
  }

  Future<void> addEvent() async {
    //TODO: 'Implement addEvent';
  }

  Future<void> deleteEvent() async {
    //TODO: 'Implement deleteEvent';
  }

  Future<void> getRelatedEvents(DateTime day) async {
    //TODO: 'Implement getRelatedEvents';
  }
}