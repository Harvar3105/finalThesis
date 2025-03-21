import 'dart:developer';

import 'package:final_thesis_app/app/models/domain/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';
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
  Set<String>? friends;
  Set<String>? friendRequests;
  Set<String>? sentFriendRequests;
  Set<String>? blockedUsers;

  User({
    super.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.email,
    this.avatarUrl,
    this.aboutMe = '',
    this.role = ERole.none,
    this.fcmToken,
    super.createdAt,
    super.updatedAt,
    this.friends = const {},
    this.friendRequests = const {},
    this.sentFriendRequests = const {},
    this.blockedUsers = const {},
  });

  @override
  String toString(){
    return '\nUser:\n'
        'id: $id\n'
        'firstName: $firstName\n'
        'lastName: $lastName\n'
        'phoneNumber: $phoneNumber\n'
        'email: $email\n'
        'avatarUrl: $avatarUrl\n'
        'aboutMe: $aboutMe\n'
        'role: $role\n'
        'fcmToken: $fcmToken\n'
        'createdAt: $createdAt\n'
        'updatedAt: $updatedAt\n'
        'friends: $friends\n'
        'friendRequests: $friendRequests\n'
        'sentFriendRequests: $sentFriendRequests\n'
        'blockedUsers: $blockedUsers\n';
  }
}

@JsonSerializable()
class UserPayload {
  @JsonKey(name: FirebaseFields.id)
  final Id? id;
  @JsonKey(name: FirebaseFields.firstName)
  final String? firstName;
  @JsonKey(name: FirebaseFields.lastName)
  final String? lastName;
  @JsonKey(name: FirebaseFields.phoneNumber)
  final String? phoneNumber;
  @JsonKey(name: FirebaseFields.email)
  final String? email;
  @JsonKey(name: FirebaseFields.avatarUrl)
  final String? avatarUrl;
  @JsonKey(name: FirebaseFields.aboutMe)
  final String? aboutMe;
  @JsonKey(name: FirebaseFields.role)
  final ERole? role;
  @JsonKey(name: FirebaseFields.fcmToken)
  final String? fcmToken;
  @JsonKey(name: FirebaseFields.createdAt)
  final DateTime? createdAt;
  @JsonKey(name: FirebaseFields.updatedAt)
  final DateTime? updatedAt;
  @JsonKey(name: FirebaseFields.friends)
  final Set<String>? friends;
  @JsonKey(name: FirebaseFields.friendRequests)
  final Set<String>? friendRequests;
  @JsonKey(name: FirebaseFields.sentFriendRequests)
  final Set<String>? sentFriendRequests;
  @JsonKey(name: FirebaseFields.blockedUsers)
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
        role: role ?? ERole.none,
        fcmToken: fcmToken,
        createdAt: createdAt,
        updatedAt: updatedAt,
        friends: friends,
        friendRequests: friendRequests,
        sentFriendRequests: sentFriendRequests,
        blockedUsers: blockedUsers,
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

  factory UserPayload.fromJson(Map<String, dynamic> json){
    var result = _$UserPayloadFromJson(json);
    // log("UserPayload.fromJson:\njson: $json\nresult: $result");
    return result;
  }

  Map<String, dynamic> toJson() => _$UserPayloadToJson(this);

  @override
  String toString(){
    return '\nUserPayload:\n'
        'id: $id\n'
        'firstName: $firstName\n'
        'lastName: $lastName\n'
        'phoneNumber: $phoneNumber\n'
        'email: $email\n'
        'avatarUrl: $avatarUrl\n'
        'aboutMe: $aboutMe\n'
        'role: $role\n'
        'fcmToken: $fcmToken\n'
        'createdAt: $createdAt\n'
        'updatedAt: $updatedAt\n'
        'friends: $friends\n'
        'friendRequests: $friendRequests\n'
        'sentFriendRequests: $sentFriendRequests\n'
        'blockedUsers: $blockedUsers\n';
  }
}