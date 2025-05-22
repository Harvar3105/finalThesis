

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/providers.dart';
import '../../../../data/domain/user.dart';

part 'users_list_view_model.g.dart';

@riverpod
class UsersListViewModel extends _$UsersListViewModel {
  List<User>? _cachedUsers;

  @override
  Future<List<User>?> build({List<User>? initialUsers}) async {
    final userService = ref.watch(userServiceProvider);
    final currentUser = await userService.getCurrentUser();
    if (currentUser == null) {
      state = AsyncValue.error("Could not get current user", StackTrace.current);
    }

    if (initialUsers != null) {
      var processedUsers = removeFriends(initialUsers, currentUser!);
      _cachedUsers = processedUsers;
      return processedUsers;
    }


    final users = removeFriends((await userService.getAllUsers()) ?? [], currentUser!);
    _cachedUsers = users;
    return users;
  }

  List<User> removeFriends(List<User> users, User currentUser){
    var sentRequests = currentUser.sentFriendRequests;
    var friendRequests = currentUser.friendRequests;
    var friends = currentUser.friends;

    users.removeWhere((u) {
      if (sentRequests != null && sentRequests.contains(u.id)) {
        return true;
      }
      if (friendRequests != null && friendRequests.contains(u.id)) {
        return true;
      }
      if (friends != null && friends.contains(u.id)) {
        return true;
      }
      return false;
    });

    return users;
  }

  Future<void> addFriend(User user) async {
    final friendshipService = ref.watch(friendshipServiceProvider);
    final result = await friendshipService.sendRequest(user);
    if (result && _cachedUsers != null) {
      _cachedUsers!.removeWhere((u) => u.id == user.id);
      state = AsyncValue.data(_cachedUsers);
    }
  }
}

