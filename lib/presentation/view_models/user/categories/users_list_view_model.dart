

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/providers.dart';
import '../../../../data/domain/user.dart';

part 'users_list_view_model.g.dart';

@riverpod
class UsersListViewModel extends _$UsersListViewModel {
  List<User>? _cachedUsers;

  @override
  Future<List<User>?> build({List<User>? initialUsers}) async {
    if (initialUsers != null) {
      _cachedUsers = initialUsers;
      return initialUsers;
    }

    final userService = ref.watch(userServiceProvider);
    final users = await userService.getAllUsers();
    _cachedUsers = users;
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

