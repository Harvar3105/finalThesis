import 'dart:developer';

import 'package:final_thesis_app/app/typedefs/e_event_privacy.dart';
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

  Future<AsyncValue<List<User>>?> saveOrUpdateEvent({
    Id? id,
    Id? creatorId,
    Id? friendId,
    required DateTime start,
    required DateTime end,
    required String title,
    required String description,
    required String location,
    required EEventPrivacy privacy,
    Duration? notifyBefore = const Duration(minutes: 30),
    Id? counterOfferOf,
  }) async {
    if (end.isBefore(start) || end == start) {
      return AsyncValue.error("End time must be after start time", StackTrace.current);
    }

    final currentUserId = creatorId ?? (await userService.getCurrentUser())?.id;
    if (currentUserId == null) {
      return AsyncValue.error("User not found", StackTrace.current);
    }

    //TODO: if counter offer of counter offer, delete previous and reference original

    final event = Event(
      id: id,
      creatorId: currentUserId,
      friendId: friendId,
      start: start,
      end: end,
      title: title,
      description: description,
      location: location,
      type: counterOfferOf == null ? EEventType.declared : EEventType.conterOffered,
      privacy: privacy,
      counterOfferOf: counterOfferOf,
      notifyBefore: notifyBefore,
    );

    if (event.counterOfferOf != null) {
      final success = await changeEventStatus(event.counterOfferOf!, EEventType.shadow);
      if (!success) {
        return AsyncValue.error("Could not change origin event status", StackTrace.current);
      }
    }

    final result = await _eventStorage.saveOrUpdateEvent(EventPayload().eventToPayload(event));
    if (!result) {
      return AsyncValue.error("Could not create event!", StackTrace.current);
    }

    return null;
  }

  Future<bool> makeDecision(Event event, bool isAccept) async {
    if (isAccept) {
      if (event.counterOfferOf != null) {
        final deletionSuccess = await deleteEventById(event.counterOfferOf!, null);
        if (!deletionSuccess) {
          return false;
        }
      }
      final updatedEventPayload = EventPayload().eventToPayload(event).copyWith(type: EEventType.accepted);
      final updateSuccess = await _eventStorage.saveOrUpdateEvent(updatedEventPayload);
      return updateSuccess;
    } else {
      if (event.counterOfferOf != null) {
        final statusChangeSuccess = await changeEventStatus(event.counterOfferOf!, EEventType.declared);
        if (!statusChangeSuccess) {
          return false;
        }
      }

      final deletionSuccess = await deleteEvent(event);
      return deletionSuccess;
    }
  }

  Future<bool> changeEventStatus(Id eventId, EEventType decision) async {
    final event = await _eventStorage.getEventById(eventId);
    if (event == null) {
      return false;
    }

    final updatedEvent = event.copyWith(
      type: decision,
    );

    return await _eventStorage.saveOrUpdateEvent(updatedEvent);
  }

  Future<bool> deleteEvent(Event event) async {
    if (event.counterOfferOf != null) {
      final success = await changeEventStatus(event.counterOfferOf!, EEventType.declared);
      if (!success) {
        return false;
      }
    }
    return await _eventStorage.deleteEvent(EventPayload().eventToPayload(event));
  }

  Future<bool> deleteEventById(Id eventId, Id? counterOfferOf) async {
    if (counterOfferOf != null) {
      final success = await changeEventStatus(counterOfferOf, EEventType.declared);
      if (!success) {
        return false;
      }
    }
    return await _eventStorage.deleteEventById(eventId);
  }
}