import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/domain/user.dart';
import '../../../view_models/user/categories/friendship_requests_view_model.dart';
import '../../widgets/animations/animation_with_text.dart';
import '../../widgets/animations/empty_animation.dart';
import '../../widgets/animations/error_animation.dart';
import '../../widgets/animations/loading/loading_animation.dart';

class FriendshipRequestsView extends ConsumerWidget {
  const FriendshipRequestsView({super.key, this.users});
  final List<User>? users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(
      friendshipRequestsViewModelProvider(preloadedUsers: users),
    );

    return requestsAsync.when(
      data: (data) {
        final user = data.$1;
        final incomingRequests = data.$2;
        final sentRequests = data.$3;

        log("FriendshipRequestsView: Got user $user, incomingRequests: $incomingRequests, sentRequests: $sentRequests");

        if (incomingRequests.isEmpty && sentRequests.isEmpty) {
          return const Center(
            child: AnimationWithText(animation: EmptyAnimationView(), text: "Sorry! No friends were found :("),
          );
        }

        return Column(
          children: [
            if (incomingRequests.isNotEmpty)
              ...incomingRequests.map((friend) => ListTile(
                title: Text(friend.firstName),
                subtitle: Text(friend.email),
                leading: CircleAvatar(
                  child: Text(friend.lastName.isNotEmpty
                      ? friend.lastName[0]
                      : '?'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        ref
                            .read(friendshipRequestsViewModelProvider(
                            preloadedUsers: users)
                            .notifier)
                            .decideFriendship(friend, true);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        ref
                            .read(friendshipRequestsViewModelProvider(
                            preloadedUsers: users)
                            .notifier)
                            .decideFriendship(friend, false);
                      },
                    ),
                  ],
                ),
              )),
            if (sentRequests.isNotEmpty)
              ...sentRequests.map((friend) => ListTile(
                title: Text(friend.firstName),
                subtitle: Text(friend.email),
                leading: CircleAvatar(
                  child: Text(friend.lastName.isNotEmpty
                      ? friend.lastName[0]
                      : '?'),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.orange),
                  onPressed: () {
                    ref
                        .read(friendshipRequestsViewModelProvider(
                        preloadedUsers: users)
                        .notifier)
                        .decideFriendship(friend, false);
                  },
                ),
              )
            ),
          ],
        );
      },
      loading: () => const AnimationWithText(
          animation: LoadingAnimationView(), text: 'Loading requests...'),
      error: (error, stackTrace) {
        log('FriendshipRequestsView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );
  }
}
