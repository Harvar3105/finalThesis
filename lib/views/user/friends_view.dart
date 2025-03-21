import 'dart:developer';

import 'package:final_thesis_app/app/services/authentication/providers/user_id.dart';
import 'package:final_thesis_app/views/widgets/decorations/divider_with_margins.dart';
import 'package:final_thesis_app/views/widgets/user/user_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/domain/user.dart';
import 'categories/friends_list_view.dart';
import 'categories/friendship_requests_view.dart';
import 'categories/users_list_view.dart';

final searchUsersProvider = StateProvider<(List<User>?, int page)?>((ref) => null);

class FriendsView extends ConsumerStatefulWidget {
  const FriendsView({super.key});

  @override
  _FriendsViewState createState() => _FriendsViewState();
}

class _FriendsViewState extends ConsumerState<FriendsView> {

  @override
  Widget build(BuildContext context) {
    var userId = ref.watch(userIdProvider);
    final (List<User>?, int page)? searchResult = ref.watch(searchUsersProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserSearch(
          onSearch: (result) {
            ref.watch(searchUsersProvider.notifier).state = result;
          },
          onFlash: (flash) {
            if (flash) {
              ref.watch(searchUsersProvider.notifier).state = null;
            }
          },
          userId: userId!,
        ),
        DividerWithMargins(1),
        Expanded(
          child: switch (searchResult?.$2) {
            0 => FriendsListView(users: searchResult?.$1),
            1 => UsersListView(users: searchResult?.$1),
            2 => FriendshipRequestsView(users: searchResult?.$1),
            _ => Text("Start searching..."),
          },
        ),
      ],
    );
  }
}