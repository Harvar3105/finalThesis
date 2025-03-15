import 'dart:developer';

import 'package:final_thesis_app/app/models/domain/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../typedefs/e_role.dart';
import '../../typedefs/entity.dart';

part 'user.g.dart';

class User extends Entity {
  String firstName;
  String lastName;
  String? phoneNumber;
  String email;
  String? avatarUrl;
  String? aboutMe;
  ERole role;
  String? fcmToken;
  Set<String> friends;
  Set<String> friendRequests;
  Set<String> sentFriendRequests;
  Set<String> blockedUsers;

  User({
    super.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.email,
    this.avatarUrl,
    this.aboutMe = '',
    this.role = ERole.None,
    this.fcmToken,
    super.createdAt,
    super.updatedAt,
    this.friends = const {},
    this.friendRequests = const {},
    this.sentFriendRequests = const {},
    this.blockedUsers = const {},
  });
}

@JsonSerializable()
class UserPayload {
  final Id? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? avatarUrl;
  final String? aboutMe;
  final ERole? role;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Set<String>? friends;
  final Set<String>? friendRequests;
  final Set<String>? sentFriendRequests;
  final Set<String>? blockedUsers;

  const UserPayload({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.avatarUrl,
    this.aboutMe,
    this.role,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.friends,
    this.friendRequests,
    this.sentFriendRequests,
    this.blockedUsers,
  });

  UserPayload userToPayload(User user) {
    return UserPayload(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      email: user.email,
      avatarUrl: user.avatarUrl,
      aboutMe: user.aboutMe,
      role: user.role,
      fcmToken: user.fcmToken,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      friends: user.friends,
      friendRequests: user.friendRequests,
      sentFriendRequests: user.sentFriendRequests,
      blockedUsers: user.blockedUsers,
    );
  }

  User? userFromPayload(){
    try {
      return User(
        id: id,
        firstName: firstName!,
        lastName: lastName!,
        phoneNumber: phoneNumber,
        email: email!,
        avatarUrl: avatarUrl,
        aboutMe: aboutMe,
        role: role ?? ERole.None,
        fcmToken: fcmToken,
        createdAt: createdAt,
        updatedAt: updatedAt,
        friends: friends ?? {},
        friendRequests: friendRequests!,
        sentFriendRequests: sentFriendRequests!,
        blockedUsers: blockedUsers!,
      );
    } catch(error) {
      log('Error in userFromPayload: $error');
      return null;
    }
  }

  //TODO: For some reason freezed object could not generate from json. Need to investigate
  UserPayload copyWith({
    Id? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? avatarUrl,
    String? aboutMe,
    ERole? role,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    Set<String>? friends,
    Set<String>? friendRequests,
    Set<String>? sentFriendRequests,
    Set<String>? blockedUsers,
  }) {
    return UserPayload(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      aboutMe: aboutMe ?? this.aboutMe,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      friends: friends ?? this.friends,
      friendRequests: friendRequests ?? this.friendRequests,
      sentFriendRequests: sentFriendRequests ?? this.sentFriendRequests,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  factory UserPayload.fromJson(Map<String, dynamic> json) =>
      _$UserPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$UserPayloadToJson(this);
}