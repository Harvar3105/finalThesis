import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/domain/user.dart';
import '../../widgets/user/user_list_item.dart';

class UsersListView extends ConsumerWidget {
  const UsersListView({super.key, required this.users});
  final List<User>? users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (users == null) return Text("Sorry, no users were found.");
    log(users!.length.toString());

    return SingleChildScrollView(
      child: ListView.builder(
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users!.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users![index];
          return UserListItem(user: user);
        },
      ),
    );
  }
}
