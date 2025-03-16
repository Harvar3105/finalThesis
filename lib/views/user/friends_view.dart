import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firends/friends_list_view.dart';
import 'firends/friendship_requests_view.dart';
import 'firends/users_list_view.dart';

class FriendsView extends ConsumerStatefulWidget {
  const FriendsView({super.key});

  @override
  _FriendsViewState createState() => _FriendsViewState();
}

class _FriendsViewState extends ConsumerState<FriendsView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                Text('Friends search'),
              ],
            ),
          ),
          SizedBox(height: 5),
          SegmentedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.colorScheme.primary;
                }
                return theme.colorScheme.secondary;
              }),
              textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.textTheme.bodySmall!;
                }
                return theme.textTheme.bodySmall!;
              }),
              padding: WidgetStatePropertyAll(const EdgeInsets.symmetric(horizontal: 20)),
            ),
            segments: [
              ButtonSegment(value: 0, label: Center(child: Text('Friends'),)),
              ButtonSegment(value: 1, label: Center(child: Text('Users'),)),
              ButtonSegment(value: 2, label: Center(child: Text('Requests'),)),
            ],
            selected: {_selectedIndex},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _selectedIndex = newSelection.first;
              });
            },
            showSelectedIcon: false,
          ),
          SizedBox(height: 5),
          // _selectedIndex == 0
          //     ? FriendsListView()
          //     : UsersListView(),
          Padding(
            padding: EdgeInsets.all(10),
            child: switch (_selectedIndex) {
              0 => FriendsListView(),
              1 => UsersListView(),
              2 => FriendshipRequestsView(),
              _ => Text("Error. Could not find view with $_selectedIndex"),
            },
          ),
        ],
      ),
    );
  }
}