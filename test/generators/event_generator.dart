import 'dart:math';

import 'package:final_thesis_app/app/typedefs/e_event_privacy.dart';
import 'package:final_thesis_app/app/typedefs/e_event_type.dart';
import 'package:final_thesis_app/data/domain/event.dart';
import 'package:final_thesis_app/data/domain/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'random_string.dart';
import 'user_generator.dart';

Random _rnd = Random();

Event generateRandomEvent(bool isNotRegistered) {
  User creator = generateRandomUser(false);
  User? friend;
  if (_rnd.nextBool()) {
    friend = generateRandomUser(false);
  }

  return Event(
    id: isNotRegistered ? null : getRandomString(4),
    creatorId: creator.id!,
    friendId: friend?.id,
    title: getRandomString(10),
    description: getRandomString(50),
    start: DateTime.now().add(Duration(days: _rnd.nextInt(1))),
    end: DateTime.now().add(Duration(days: _rnd.nextInt(10))),
    location: LatLng(48.8566, 2.3522),
    type: EEventType.declared,
    privacy: friend != null ? EEventPrivacy.public : EEventPrivacy.private,
    notifyBefore: Duration(minutes: _rnd.nextInt(60)),
  );
}