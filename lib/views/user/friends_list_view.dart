
import 'dart:developer';

import 'package:final_thesis_app/app/storage/user/combined_user_friends.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsListView extends ConsumerStatefulWidget {
  const FriendsListView({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendsListViewState();
}

class _FriendsListViewState extends ConsumerState<FriendsListView> {
  @override
  Widget build(BuildContext context) {
    final combinedAsync = ref.watch(combinedUserWithFriendsProvider);

    return combinedAsync.when(
      data: (data) {
        final user = data.$1;
        final friends = data.$2;
        log('FriendsListView: Got user $user and friends $friends');

        if (friends.isEmpty) {
          return const Center(
            child: Text('Oops! You have no friends yet. Why not find some? :)'),
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
                child: Text(friend.lastName.isNotEmpty
                    ? friend.lastName[0]
                    : '?'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}