import 'package:final_thesis_app/app/domain/calendar.dart';
import 'package:final_thesis_app/app/domain/entity.dart';

import '../typedefs/entity.dart';

class Event extends Entity {
  final DateTime start;
  final DateTime end;
  final String title;
  final String description;
  final String location;

  final Id? CalendarId;
  final Calendar? calendar;

  Event({
    super.id,
    required this.start,
    required this.end,
    required this.title,
    required this.description,
    required this.location,
    this.CalendarId,
    this.calendar,
  });

}