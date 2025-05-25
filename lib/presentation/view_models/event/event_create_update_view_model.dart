import 'dart:async';

import 'package:final_thesis_app/data/domain/event.dart';
import 'package:final_thesis_app/presentation/view_models/calendar/day_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../app/typedefs/e_event_privacy.dart';
import '../../../app/typedefs/entity.dart';
import '../../../data/domain/user.dart';

part 'event_create_update_view_model.g.dart';

@riverpod
class EventCreateUpdateViewModel extends _$EventCreateUpdateViewModel {
  Event? editingEvent;
  User? selectedFriend;
  User? originalUser;
  late User currentUser;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  LatLng? location;
  DateTime? startTime;
  DateTime? endTime;
  Duration notifyBefore = const Duration(minutes: 30);
  Id? _id;
  Id? _creatorId;
  bool _isPrivate = false;

  @override
  FutureOr<List<User>> build({Event? event, bool isCounterOffer = false}) async {
    editingEvent = event;
    await _initializeFields(isCounterOffer);
    if (isCounterOffer) return [];
    return _loadFriends();
  }

  Future<void> _initializeFields(bool isCounterOffer) async {
    final userService = ref.read(userServiceProvider);
    currentUser = (await userService.getCurrentUser())!;


    if (editingEvent != null) {
      if (editingEvent!.friendId != null) {
        selectedFriend = await userService.getUserById(editingEvent!.friendId!);
      }
      originalUser = await userService.getUserById(editingEvent!.creatorId);

      _id = isCounterOffer ? null :  editingEvent!.id;
      _creatorId = isCounterOffer ? currentUser!.id! : editingEvent!.creatorId;
      titleController.text = editingEvent!.title;
      descriptionController.text = editingEvent!.description;
      location = location ?? editingEvent!.location;
      startTime = editingEvent!.start;
      endTime = editingEvent!.end;
      notifyBefore = editingEvent!.notifyBefore ?? const Duration(minutes: 30);
    } else {
      originalUser = await userService.getCurrentUser();
    }
  }

  Future<void> setStartTime(DateTime date) async {
    startTime = date;
    state = state;
  }

  Future<void> setEndTime(DateTime date) async {
    endTime = date;
    state = state;
  }

  Future<List<User>> _loadFriends() async {
    final userService = ref.read(userServiceProvider);
    final currentUser = await userService.getCurrentUser();
    if (currentUser == null) throw Exception("User not found");

    final friends = await userService.getUsersFriends(currentUser);
    if (friends == null || friends.isEmpty) {
      _isPrivate = true;
      return [];
    }

    return friends;
  }

  void togglePrivacy() {
    _isPrivate = !_isPrivate;
    state = state;
  }
  bool get isPrivate => _isPrivate;

  Future<(bool, String)> saveOrUpdateEvent() async {
    if (startTime == null || endTime == null) {
      return (false, "Start and end time must be set");
    }
    if (location == null) {
      return (false, "Location must be set");
    }

    final eventService = ref.read(eventServiceProvider);
    final result = await eventService.saveOrUpdateEvent(
      id: _id,
      creatorId: _creatorId,
      friendId: _isPrivate? null : isCounterOffer ? editingEvent!.creatorId : selectedFriend!.id!,
      start: startTime!,
      end: endTime!,
      title: titleController.text,
      privacy: _isPrivate ? EEventPrivacy.private : EEventPrivacy.public,
      description: descriptionController.text,
      location: location!,
      notifyBefore: notifyBefore,
      counterOfferOf: editingEvent?.id,
    );

    if (result == null) {
      var currentUser = await ref.read(userServiceProvider).getCurrentUser();
      if (currentUser != null) {
        ref.invalidate(dayViewModelProvider(user: currentUser));
      }
      return (true, "Success");
    }
    return (false, "Could not save event: $result");
  }
}