
import 'dart:async';

import 'package:final_thesis_app/data/domain/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';

part 'day_view_model.g.dart';

@riverpod
class DayViewModel extends _$DayViewModel {
  @override
  Future<List<Event>?> build() {
    final correspondingEvents = ref.read(eventServiceProvider);

    final events = correspondingEvents.getAllEvents();

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