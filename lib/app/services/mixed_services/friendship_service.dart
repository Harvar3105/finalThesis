import 'dart:developer';

import 'package:final_thesis_app/app/services/push/push_notifications_service.dart';

import '../../../data/domain/user.dart';
import '../user/user_service.dart';

class FriendshipService {
  final UserService _userService;
  final PushNotificationsService _notificationsService;

  FriendshipService(this._userService, this._notificationsService);

  Future<bool> sendRequest(User user) async {
    final currentUser = await _userService.getCurrentUser();

    if (currentUser == null) {
      log("Cannot get current user!");
      return false;
    }

    if (currentUser.sentFriendRequests == null) {
      currentUser.sentFriendRequests = {user.id!};
    } else {
      currentUser.sentFriendRequests!.add(user.id!);
    }

    if (user.friendRequests == null) {
      user.friendRequests = {currentUser.id!};
    } else {
      user.friendRequests!.add(currentUser.id!);
    }

    try {
      await _userService.saveOrUpdateUser(currentUser);
      await _userService.saveOrUpdateUser(user);
      log("Friend request sent to ${user.firstName} ${user.lastName}");
      //TODO: add notification about this later. Maybe via firebase functions
      return true;
    } catch (e, stackTrace) {
      log("Error sending friend request: $e", stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> decideFriendship(User user, bool isAccept) async {
    final currentUser =  await _userService.getCurrentUser();
    if (currentUser == null) {
      log("Cannot get current user!");
      return false;
    }

    if (currentUser.friendRequests == null || user.sentFriendRequests == null){
      log("Someon's list not initialized properly! C.u. ${currentUser.friendRequests}, u: ${user.sentFriendRequests}");
      return false;
    }
    if (isAccept) {
      currentUser.friends ??= {};
      currentUser.friends!.add(user.id!);
      user.friends ??= {};
      user.friends!.add(currentUser.id!);
    }
    currentUser.friendRequests?.removeWhere((id) => id == user.id);
    currentUser.sentFriendRequests?.removeWhere((id) => id == user.id);
    user.sentFriendRequests?.removeWhere((id) => id == currentUser.id);
    user.friendRequests?.removeWhere((id) => id == currentUser.id);

    try {
      _userService.saveOrUpdateUser(user);
      _userService.saveOrUpdateUser(currentUser);
      //TODO: add notification about this later. Maybe via firebase functions
      return true;
    } catch (error, stackTrace) {
      log("Could not save users friendship acceptance! Cause: $error", stackTrace: stackTrace);
      return false;
    }
  }
}