import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/domain/user.dart';
import '../../view_models/authentication/other_providers/user_id.dart';
import '../widgets/decorations/divider_with_margins.dart';
import '../widgets/user/user_search.dart';
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
            log("result: $result");
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
            0 => FriendsListView(users: searchResult?.$2 == 0 ? searchResult?.$1 : null),
            1 => UsersListView(users: searchResult?.$2 == 1 ? searchResult?.$1 : null),
            2 => FriendshipRequestsView(users: searchResult?.$2 == 2 ? searchResult?.$1 : null),
            _ => Text("Start searching..."),
          },
        ),
      ],
    );
  }
}