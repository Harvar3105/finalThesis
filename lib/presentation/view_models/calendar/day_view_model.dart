
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'day_view_model.g.dart';

@riverpod
class DayViewModel extends _$DayViewModel {
  @override
  FutureOr<void> build() {}

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