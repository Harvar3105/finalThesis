import 'dart:developer';

import 'package:final_thesis_app/app/typedefs/e_event_privacy.dart';
import 'package:final_thesis_app/app/typedefs/e_event_type.dart';
import 'package:final_thesis_app/data/domain/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/typedefs/entity.dart';
import '../../configurations/firebase/firebase_access_fields.dart';

part 'event.g.dart';

class Event extends Entity {
  final Id creatorId;
  final Id? friendId;
  DateTime start;
  DateTime end;
  String title;
  String description;
  String location; //TODO: change to Location
  EEventType type;
  final EEventPrivacy privacy;
  Id? counterOfferOf;
  Duration? notifyBefore;

  Event({
    super.id,
    required this.creatorId,
    this.friendId,
    required this.start,
    required this.end,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.privacy,
    this.counterOfferOf,
    this.notifyBefore,
    super.createdAt,
    super.updatedAt,
  });

  @override
  String toString() {
    return '\nEvent:\n'
      'id: $id\n'
      'creatorId: $creatorId\n'
      'friendId: $friendId\n'
      'start: $start\n'
      'end: $end\n'
      'title: $title\n'
      'description: $description\n'
      'location: $location\n'
      'type: $type\n'
      'privacy: $privacy\n'
      'counterOfferOf: $counterOfferOf\n'
      'notifyBefore: $notifyBefore\n';
  }
}

@JsonSerializable()
class EventPayload {
  @JsonKey(name: FirebaseFields.id)
  final Id? id;
  @JsonKey(name: FirebaseFields.creatorId)
  final Id? creatorId;
  @JsonKey(name: FirebaseFields.friendId)
  final Id? friendId;
  @JsonKey(name: FirebaseFields.start)
  final DateTime? start;
  @JsonKey(name: FirebaseFields.end)
  final DateTime? end;
  @JsonKey(name: FirebaseFields.title)
  final String? title;
  @JsonKey(name: FirebaseFields.description)
  final String? description;
  @JsonKey(name: FirebaseFields.location)
  final String? location; //TODO: change to Location
  @JsonKey(name: FirebaseFields.type)
  final EEventType? type;
  @JsonKey(name: FirebaseFields.privacy)
  final EEventPrivacy? privacy;
  @JsonKey(name: FirebaseFields.counterOfferOf)
  final Id? counterOfferOf;
  @JsonKey(name: FirebaseFields.notifyBefore)
  final Duration? notifyBefore;
  @JsonKey(name: FirebaseFields.createdAt)
  final DateTime? createdAt;
  @JsonKey(name: FirebaseFields.updatedAt)
  final DateTime? updatedAt;

  const EventPayload({
    this.id,
    this.creatorId,
    this.friendId,
    this.start,
    this.end,
    this.title,
    this.description,
    this.location,
    this.type,
    this.privacy,
    this.counterOfferOf,
    this.notifyBefore,
    this.createdAt,
    this.updatedAt,
  });

  EventPayload eventToPayload(Event event) {
    return EventPayload(
      id: event.id,
      creatorId: event.creatorId,
      friendId: event.friendId,
      start: event.start,
      end: event.end,
      title: event.title,
      description: event.description,
      location: event.location,
      type: event.type,
      privacy: event.privacy,
      counterOfferOf: event.counterOfferOf,
      notifyBefore: event.notifyBefore,
      createdAt: event.createdAt,
      updatedAt: event.updatedAt,
    );
  }

  Event? eventFromPayload(){
    try {
      return Event(
        id: id!,
        creatorId: creatorId!,
        friendId: friendId,
        start: start!,
        end: end!,
        title: title!,
        description: description!,
        location: location!,
        type: type!,
        privacy: privacy!,
        counterOfferOf: counterOfferOf,
        notifyBefore: notifyBefore,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch(error) {
      log('Error in eventFromPayload: $error');
      return null;
    }
  }

  EventPayload copyWith({
    Id? id,
    Id? firstUserId,
    Id? secondUserId,
    DateTime? start,
    DateTime? end,
    String? title,
    String? description,
    String? location,
    EEventType? type,
    EEventPrivacy? privacy,
    Id? counterOfferOf,
    Duration? notifyBefore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventPayload(
      id: id ?? this.id,
      creatorId: firstUserId ?? creatorId,
      friendId: secondUserId ?? friendId,
      start: start ?? this.start,
      end: end ?? this.end,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      type: type ?? this.type,
      privacy: privacy ?? this.privacy,
      counterOfferOf: counterOfferOf ?? this.counterOfferOf,
      notifyBefore: notifyBefore ?? this.notifyBefore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory EventPayload.fromJson(Map<String, dynamic> json) {
    var result = _$EventPayloadFromJson(json);
    // log("EventPayload.fromJson:\njson: $json\nresult: $result");
    return result;
  }
  Map<String, dynamic> toJson() => _$EventPayloadToJson(this);

  @override
  String toString() {
    return '\nEventPayload:\n'
      'id: $id\n'
      'creatorId: $creatorId\n'
      'friendId: $friendId\n'
      'start: $start\n'
      'end: $end\n'
      'title: $title\n'
      'description: $description\n'
      'location: $location\n'
      'type: $type\n'
      'privacy: $privacy\n'
      'counterOfferOf: $counterOfferOf\n'
      'notifyBefore: $notifyBefore\n'
      'createdAt: $createdAt\n'
      'updatedAt: $updatedAt\n';
  }
}
