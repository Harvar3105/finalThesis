import 'package:final_thesis_app/app/models/domain/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../typedefs/e_role.dart';
import '../../typedefs/entity.dart';

part 'user.g.dart';

class User extends Entity {
  String firstName;
  String lastName;
  String phoneNumber;
  String? email;
  String? avatarUrl;
  String aboutMe;
  ERole role;
  String? fcmToken;

  User({
    super.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.avatarUrl,
    this.aboutMe = '',
    this.role = ERole.None,
    this.fcmToken
  });
}

@JsonSerializable()
class UserPayload {
  final Id? userId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? avatarUrl;
  final String? aboutMe;
  final ERole? role;
  final String? fcmToken;

  const UserPayload({
    this.userId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.avatarUrl,
    this.aboutMe,
    this.role,
    this.fcmToken,
  });

  userToPayload(User user) {
    return UserPayload(
      userId: user.id ?? Uuid().v4(),
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      email: user.email,
      avatarUrl: user.avatarUrl,
      aboutMe: user.aboutMe,
      role: user.role,
      fcmToken: user.fcmToken,
    );
  }

  //TODO: For some reason freezed object could not generate from json. Need to investigate
  UserPayload copyWith({
    Id? userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? avatarUrl,
    String? aboutMe,
    ERole? role,
    String? fcmToken,
  }) {
    return UserPayload(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      aboutMe: aboutMe ?? this.aboutMe,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory UserPayload.fromJson(Map<String, dynamic> json) =>
      _$UserPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$UserPayloadToJson(this);
}