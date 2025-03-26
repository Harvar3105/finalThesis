import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/domain/user.dart';
import '../../../view_models/user/categories/users_list_view_model.dart';

class UsersListView extends ConsumerWidget {
  final List<User>? users;
  const UsersListView({super.key, required this.users});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersListViewModelProvider(initialUsers: users));
    final usersNotifier = ref.read(usersListViewModelProvider(initialUsers: users).notifier);

    return usersState.when(
      data: (usersList) {
        if (usersList == null || usersList.isEmpty) {
          return const Center(child: Text("Sorry, no users were found."));
        }

        log("Users count: ${usersList.length}");

        return SingleChildScrollView(
          child: ListView.builder(
            padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: usersList.length,
            itemBuilder: (BuildContext context, int index) {
              final user = usersList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : const AssetImage("assets/images/user_icon.png") as ImageProvider,
                ),
                title: Text("${user.firstName} ${user.lastName}"),
                subtitle: Text(user.email),
                trailing: ElevatedButton(
                  onPressed: () => usersNotifier.addFriend(user),
                  child: const Text("Add Friend"),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        log("Error loading users: $error");
        return const Center(child: Text("Failed to load users."));
      },
    );
  }
}
