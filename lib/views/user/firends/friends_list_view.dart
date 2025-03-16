
import 'dart:developer';

import 'package:final_thesis_app/app/storage/user/combined/combined_user_friends.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsListView extends ConsumerWidget {
  const FriendsListView({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combinedAsync = ref.watch(combinedUserWithFriendsProvider);

    return combinedAsync.when(
      data: (data) {
        final user = data.$1;
        final friends = data.$2;
        log('FriendsListView: Got user $user and friends $friends');

        if (friends.isEmpty) {
          return const Center(
            child: Text('Oops! You have no friends yet. Why not find some?\n:)'),
          );
        }

        return SingleChildScrollView(
          child: ListView.builder(
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
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
