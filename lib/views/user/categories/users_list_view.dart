import 'dart:developer';

import 'package:final_thesis_app/views/widgets/user/user_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/models/domain/user.dart';
import '../../../app/storage/user/combined/combined_user_users.dart';
import '../../widgets/animations/animation_with_text.dart';
import '../../widgets/animations/error_animation.dart';
import '../../widgets/animations/loading/loading_animation.dart';

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
