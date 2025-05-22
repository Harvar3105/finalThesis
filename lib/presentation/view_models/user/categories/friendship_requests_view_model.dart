import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/domain/user.dart';
import '../../../../app/services/providers.dart';

part 'friendship_requests_view_model.g.dart';

@riverpod
class FriendshipRequestsViewModel extends _$FriendshipRequestsViewModel {
  List<User>? _cachedIncomingRequests;
  List<User>? _cachedOutcomingRequests;

  @override
  Future<(User, List<User>, List<User>)> build({List<User>? preloadedUsers}) async {
    final userService = ref.watch(userServiceProvider);

    final User? user = await userService.getCurrentUser();
    if (user == null) {
      throw Exception("Failed to get current user");
    }

    if (preloadedUsers != null) {
      return (user, preloadedUsers, [].cast<User>());
    }

    final incomingRequests = await userService.getUsersByIds(user.friendRequests ?? {});
    final sentRequests = await userService.getUsersByIds(user.sentFriendRequests ?? {});

    _cachedIncomingRequests = incomingRequests;
    _cachedOutcomingRequests = sentRequests;

    return (user, incomingRequests ?? [], sentRequests ?? []);
  }

  Future<void> addFriends(User user) async {
    final friendshipService = ref.watch(friendshipServiceProvider);
    final result = await friendshipService.sendRequest(user);
    if (result) {
      _cachedIncomingRequests!.removeWhere((id) => id == user.id);
      state = AsyncValue.data((
        state.value!.$1,
        _cachedIncomingRequests!,
        _cachedOutcomingRequests ?? [],
      ));
    }
  }

  Future<void> decideFriendship(User user, bool isAccept) async {
    final friendshipService = ref.watch(friendshipServiceProvider);
    final result = await friendshipService.decideFriendship(user, isAccept);
    if (result) {
      if (_cachedOutcomingRequests != null) {
        _cachedOutcomingRequests!.removeWhere((id) => id == user.id);
      }
      if (_cachedIncomingRequests != null) {
        _cachedIncomingRequests!.removeWhere((id) => id == user.id);
      }
      state = AsyncValue.data((
        state.value!.$1,
        _cachedIncomingRequests ?? [],
        _cachedOutcomingRequests ?? [],
      ));
    }
  }
}
