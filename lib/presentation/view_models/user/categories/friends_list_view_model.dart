import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/domain/user.dart';
import '../../../../app/services/providers.dart';

part 'friends_list_view_model.g.dart';

@riverpod
class FriendsListViewModel extends _$FriendsListViewModel {
  @override
  Future<(User, List<User>)> build({List<User>? preloadedFriends}) async {
    final userService = ref.watch(userServiceProvider);

    final user = await userService.getCurrentUser();
    if (user == null) {
      throw Exception("Failed to get current user");
    }

    if (preloadedFriends != null) {
      return (user, preloadedFriends);
    }

    final friends = await userService.getUsersFriends(user);
    return (user, friends ?? []);
  }
}
