import 'dart:async';

import 'package:final_thesis_app/data/domain/event.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../app/typedefs/e_event_type.dart';
import '../../../app/typedefs/entity.dart';
import '../../../data/domain/user.dart';

part 'event_create_view_model.g.dart';

@riverpod
class EventCreateViewModel extends _$EventCreateViewModel {
  @override
  FutureOr<List<User>> build() async {
    return await _loadFriends();
  }

  Future<List<User>> _loadFriends() async {
    final userService = ref.read(userServiceProvider);
    final currentUser = await userService.getCurrentUser();
    if (currentUser == null) {
      state = AsyncValue.error("User not found", StackTrace.current);
      return [];
    }

    final friends = await userService.getUsersFriends(currentUser);
    if (friends == null || friends.isEmpty) {
      state = AsyncValue.error("User has no friends, add some first", StackTrace.current);
      return [];
    }

    state = AsyncValue.data(friends);
    return friends;
  }

  Future<bool> createEvent({
    required Id otherUserId,
    required DateTime start,
    required DateTime end,
    required String title,
    required String description,
    required String location,
    Duration? notifyBefore = const Duration(minutes: 30)
  }) async {
    final eventService = ref.read(eventServiceProvider);
    final result = await eventService.saveOrUpdateEvent(
      otherUserId: otherUserId,
      start: start,
      end: end,
      title: title,
      description: description,
      location: location,
      notifyBefore: notifyBefore,
    );

    if (result != null) {
      state = result;
      return false;
    } else {
      return true;
    }
  }
}