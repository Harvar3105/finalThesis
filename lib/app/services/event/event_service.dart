import 'package:final_thesis_app/data/domain/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/domain/event.dart';
import '../../../data/repositories/event/event_storage.dart';
import '../../typedefs/e_event_type.dart';
import '../../typedefs/entity.dart';
import '../user/user_service.dart';

class EventService {
  final EventStorage _eventStorage;
  final UserService userService;

  EventService(this._eventStorage, this.userService);

  Future<Event?> getEventById(String id) async {
    return (await _eventStorage.getEventById(id))?.eventFromPayload();
  }

  Future<List<Event>?> getEventsByDate(DateTime date) async {
    return (await _eventStorage.getEventsByDate(date))
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<List<Event>?> getAllEvents() async {
    return (await _eventStorage.getAllEvents())
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<List<Event>?> getEventsByUserId(String userId, bool isCoach) async {
    return (await _eventStorage.getEventsByUserId(userId, isCoach))
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<AsyncValue<List<User>>?> createNewEvent({
    required Id otherUserId,
    required DateTime start,
    required DateTime end,
    required String title,
    required String description,
    required String location,
    Duration? notifyBefore = const Duration(minutes: 30)
  }) async {
    if (end.isBefore(start) || end == start) {
      return AsyncValue.error("End time must be after start time", StackTrace.current);
    }

    final currentUser = await userService.getCurrentUser();
    if (currentUser == null) {
      return AsyncValue.error("User not found", StackTrace.current);
    }

    final event = Event(
      firstUserId: currentUser.id!,
      secondUserId: otherUserId,
      start: start,
      end: end,
      title: title,
      description: description,
      location: location,
      type: EEventType.Declared,
      notifyBefore: notifyBefore,
    );
    final result = await _eventStorage.saveOrUpdateEvent(EventPayload().eventToPayload(event));
    if (!result) {
      return AsyncValue.error("Could not create event!", StackTrace.current);
    }

    return null;
  }

  Future<bool> deleteEvent(Event event) async {
    return await _eventStorage.deleteEvent(EventPayload().eventToPayload(event));
  }
}