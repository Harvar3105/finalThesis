import 'dart:math';
import 'package:final_thesis_app/app/typedefs/e_role.dart';
import 'package:final_thesis_app/data/domain/user.dart';

import 'random_string.dart';

Random _rnd = Random();

User generateRandomUser(bool isNotRegistered) {
    return User(
      id: isNotRegistered ? null : getRandomString(4),
      firstName: getRandomString(10),
      lastName: getRandomString(10),
      phoneNumber: getRandomString(10),
      email: '${getRandomString(10)}@example.com',
      avatarUrl: isNotRegistered ? null : 'https://example.com/avatar/${getRandomString(10)}.png',
      avatarThumbnailUrl: isNotRegistered ? null : 'https://example.com/avatar/thumbnail/${getRandomString(10)}.png',
      aboutMe: getRandomString(50),
      role: _rnd.nextBool() ? ERole.coach : ERole.athlete,
      fcmToken: null,
    );
}