import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/domain/user.dart';
import '../../../../app/services/user/user_service.dart';
import '../../../../app/services/providers.dart';

part 'friendship_requests_view_model.g.dart';

@riverpod
class FriendshipRequestsViewModel extends _$FriendshipRequestsViewModel {
  Future<(User, List<User>, List<User>)> build({List<User>? preloadedUsers}) async {
    final userService = ref.watch(userServiceProvider);

    final User? user = await userService.getCurrentUser();
    if (user == null) {
      throw Exception("Failed to get current user");
    }

    if (preloadedUsers != null) {
      return (user, preloadedUsers, [] as List<User>);
    }

    final incomingRequests = await userService.getUsersByIds(user.friendRequests ?? {});
    final sentRequests = await userService.getUsersByIds(user.sentFriendRequests ?? {});

    return (user, incomingRequests ?? [], sentRequests ?? []);
  }
}
