import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/storage/user/combined/combined_user_users.dart';

class UsersListView extends ConsumerWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combinedAsync = ref.watch(combinedUserWithUsersProvider);

    return combinedAsync.when(
      data: (data) {
        final user = data.$1;
        final users = data.$2;

        if (users.isEmpty) {
          return const Center(
            child: Text('Oops! No users found. You are the first visitor!\n:)'),
          );
        }

        return SingleChildScrollView(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final friend = users[index];
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
