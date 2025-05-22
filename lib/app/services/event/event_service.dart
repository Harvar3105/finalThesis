
import 'dart:developer';

import 'package:final_thesis_app/app/services/push/push_notifications_service.dart';
import 'package:final_thesis_app/app/typedefs/e_event_privacy.dart';
import 'package:final_thesis_app/data/domain/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/domain/event.dart';
import '../../../data/repositories/event/event_storage.dart';
import '../../typedefs/e_event_type.dart';
import '../../typedefs/entity.dart';
import '../user/user_service.dart';

class EventService {
  final EventStorage _eventStorage;
  final UserService userService;
  final PushNotificationsService _pushNotificationsService;

  EventService(this._eventStorage, this.userService, this._pushNotificationsService);

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
    return (await _eventStorage.getEventsByUserId(userId))
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<List<Event>?> getProcessedEventsByUserId(Id userId) async {
    return (await _eventStorage.getProcessedEventsByUserId(userId))
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<List<Event>?> getProcessedEventsByUserAndFriendIds(Id user1Id, Id user2Id) async {
    return (await _eventStorage.getProcessedEventsByUserAndFriendIds(user1Id, user2Id))
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<int> getProcessedEventCountByUserPair(Id user1Id, Id user2Id) async {
    return (await _eventStorage.getProcessedEventCountByUserPair(user1Id, user2Id));
  }

  Future<AsyncValue<List<User>>?> saveOrUpdateEvent({
    Id? id,
    Id? creatorId,
    Id? friendId,
    required DateTime start,
    required DateTime end,
    required String title,
    required String description,
    required LatLng location,
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

    var type = EEventType.conterOffered;
    if (counterOfferOf == null) {
      type = privacy == EEventPrivacy.private ? EEventType.accepted : EEventType.declared;
    }

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

    if (event.friendId != null) {
      final user = await userService.getUserById(event.creatorId);
      final friend = await userService.getUserById(event.friendId!);

      if (event.counterOfferOf != null) {
        _pushNotificationsService.pushNotification(friend!,
          'Your fiend ${user?.firstName} ${user?.lastName} made counter offer!',
          "User ${user?.firstName} ${user?.lastName} has made a counter offer for ${event.title}!"
        );
      } else {
        _pushNotificationsService.pushNotification(friend!,
          "Your friend ${user?.firstName} ${user?.lastName} has invited you!",
          "User ${user?.firstName} ${user?.lastName} has invited you to an event: ${event.title},\n${event.description}.\n At ${event.start} - ${event.end}"
        );
      }
    }

    return null;
  }

  Future<bool> makeDecision(Event event, bool isAccept) async {
    final user = await userService.getUserById(event.creatorId);
    final friend = await userService.getUserById(event.friendId!);

    if (isAccept) {
      if (event.counterOfferOf != null) {
        final result = await deleteOtherCounterOffers(event);
        if (!result) {
          log("Could not delete other counter offers");
          return false;
        }
      }
      final updatedEventPayload = EventPayload().eventToPayload(event).copyWith(type: EEventType.accepted);
      final updateSuccess = await _eventStorage.saveOrUpdateEvent(updatedEventPayload);

      if (user != null) {
        _pushNotificationsService.pushNotification(user, "${event.title} has been accepted!",
            "Your event ${event.title} has been accepted by ${friend?.firstName} ${friend?.lastName}!}");
      }

      return updateSuccess;
    } else {
      if (event.counterOfferOf != null) {
        final nextCounterOffer = await _eventStorage.getEventCounterOffer(event.id!);
        if (nextCounterOffer != null) {
          final updatedPayload = nextCounterOffer.copyWith(counterOfferOf: event.counterOfferOf);
          await _eventStorage.saveOrUpdateEvent(updatedPayload);
        } else {
          final statusChangeSuccess = await changeEventStatus(event.counterOfferOf!, EEventType.declared);
          if (!statusChangeSuccess) {
            return false;
          }
        }
      }

      final deletionSuccess = await deleteEvent(event);

      if (user != null) {
        _pushNotificationsService.pushNotification(user, "${event.title} has been declined!",
            "Your event ${event.title} has been declined by ${friend?.firstName} ${friend?.lastName}!}");
      }

      return deletionSuccess;
    }
  }

  // TODO: test it
  Future<bool> deleteOtherCounterOffers(Event event) async {
    final user = await userService.getCurrentUser();
    if (user == null) {
      log("Could not get current user");
      return false;
    }

    final relatedEvents = await _eventStorage.getEventsByUserId(user.id!);
    if (relatedEvents == null) {
      log("Could not get related events");
      return false;
    }

    relatedEvents.removeWhere((e) => e.id == event.id);
    EventPayload? previousEvent = relatedEvents.firstWhere((e) => e.id == event.counterOfferOf);
    while (previousEvent != null) {
      final deletionSuccess = await deleteEventById(previousEvent.id!, null);
      if (!deletionSuccess) {
        return false;
      }

      relatedEvents.removeWhere((e) => e.id == previousEvent!.id);
      if (previousEvent.counterOfferOf == null) {
        previousEvent = null;
      } else {
        previousEvent = relatedEvents.firstWhere((e) => e.id == previousEvent!.counterOfferOf);
      }
    }

    EventPayload? nextEvent = relatedEvents
        .where((e) => e.counterOfferOf == event.id)
        .cast<EventPayload?>()
        .firstOrNull;
    while (nextEvent != null) {
      final deletionSuccess = await deleteEventById(nextEvent.id!, null);
      if (!deletionSuccess) {
        return false;
      }

      relatedEvents.removeWhere((e) => e.id == nextEvent!.id);
      EventPayload? newNextEvent = relatedEvents
          .where((e) => e.counterOfferOf == event.id)
          .cast<EventPayload?>()
          .firstOrNull;
      if (newNextEvent == null) {
        nextEvent = null;
      } else {
        nextEvent = relatedEvents
            .where((e) => e.id == newNextEvent.counterOfferOf)
            .cast<EventPayload?>()
            .firstOrNull;
      }
    }
    return true;
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
      // if (!success) {
      //   return false;
      // }
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