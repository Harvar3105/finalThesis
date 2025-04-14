
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../configurations/strings.dart';
import '../../../../data/domain/user.dart';
import '../../../view_models/user/categories/friends_list_view_model.dart';
import '../../widgets/animations/animation_with_text.dart';
import '../../widgets/animations/empty_animation.dart';
import '../../widgets/animations/error_animation.dart';
import '../../widgets/animations/loading/loading_animation.dart';

class FriendsListView extends ConsumerWidget {
  const FriendsListView({super.key, this.users});
  final List<User>? users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(
      friendsListViewModelProvider(preloadedFriends: users),
    );
    final viewModel = ref.read(friendsListViewModelProvider(preloadedFriends: users).notifier);

    return dataAsync.when(
      data: (data) {
        final user = data.$1;
        final friends = data.$2;

        if (friends.isEmpty) {
          return const Center(
            child: AnimationWithText(animation: EmptyAnimationView(), text: "Sorry! No friends were found :(\n WIP, press search button to rerender!"),
          );
        }

        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (BuildContext context, int index) {
            final friend = friends[index];
            return ListTile(
              title: Text(friend.firstName),
              subtitle: Text(friend.email),
              leading: CircleAvatar(
                child: Text(friend.lastName.isNotEmpty ? friend.lastName[0] : '?'),
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  GoRouter.of(context).pushNamed(Strings.chat, extra: await viewModel.getDirectChat(user, friend));
                },
                child: Icon(Icons.send_outlined, color: Theme.of(context).iconTheme.color)
              ),
            );
          },
        );
      },
      loading: () => const AnimationWithText(
          animation: LoadingAnimationView(), text: 'Loading friends...'),
      error: (error, stackTrace) {
        log('FriendsListView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );
  }
}
