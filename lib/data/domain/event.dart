import 'dart:developer';

import 'package:final_thesis_app/app/typedefs/e_event_type.dart';
import 'package:final_thesis_app/data/domain/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/typedefs/entity.dart';
import '../../configurations/firebase/firebase_access_fields.dart';

part 'event.g.dart';

class Event extends Entity {
  final DateTime start;
  final DateTime end;
  final String title;
  final String description;
  final String location; //TODO: change to Location
  final EEventType type;
  final Duration? notifyBefore;

  Event({
    super.id,
    required this.start,
    required this.end,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    this.notifyBefore,
    super.createdAt,
    super.updatedAt,
  });

  @override
  String toString() {
    return '\nEvent:\n'
        'id: $id\n'
        'start: $start\n'
        'end: $end\n'
        'title: $title\n'
        'description: $description\n'
        'location: $location\n'
        'type: $type\n'
        'notifyBefore: $notifyBefore\n';
  }
}

@JsonSerializable()
class EventPayload {
  @JsonKey(name: FirebaseFields.id)
  final Id? id;
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
  @JsonKey(name: FirebaseFields.notifyBefore)
  final Duration? notifyBefore;
  @JsonKey(name: FirebaseFields.createdAt)
  final DateTime? createdAt;
  @JsonKey(name: FirebaseFields.updatedAt)
  final DateTime? updatedAt;

  const EventPayload({
    this.id,
    this.start,
    this.end,
    this.title,
    this.description,
    this.location,
    this.type,
    this.notifyBefore,
    this.createdAt,
    this.updatedAt,
  });

  EventPayload eventToPayload(Event event) {
    return EventPayload(
      id: event.id,
      start: event.start,
      end: event.end,
      title: event.title,
      description: event.description,
      location: event.location,
      type: event.type,
      notifyBefore: event.notifyBefore,
      createdAt: event.createdAt,
      updatedAt: event.updatedAt,
    );
  }

  Event? eventFromPayload(){
    try {
      return Event(
        start: start!,
        end: end!,
        title: title!,
        description: description!,
        location: location!,
        type: type!,
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
    DateTime? start,
    DateTime? end,
    String? title,
    String? description,
    String? location,
    EEventType? type,
    Duration? notifyBefore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventPayload(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      type: type ?? this.type,
      notifyBefore: notifyBefore ?? this.notifyBefore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory EventPayload.fromJson(Map<String, dynamic> json) {
    var result = _$EventPayloadFromJson(json);
    log("EventPayload.fromJson:\njson: $json\nresult: $result");
    return result;
  }
  Map<String, dynamic> toJson() => _$EventPayloadToJson(this);

  @override
  String toString() {
    return '\nEventPayload:\n'
      'id: $id\n'
      'start: $start\n'
      'end: $end\n'
      'title: $title\n'
      'description: $description\n'
      'location: $location\n'
      'type: $type\n'
      'notifyBefore: $notifyBefore\n'
      'createdAt: $createdAt\n'
      'updatedAt: $updatedAt\n';
  }
}
