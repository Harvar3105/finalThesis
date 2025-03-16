import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firends/friends_list_view.dart';
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
          Row(
            children: [
              Text('Friends search'),
            ],
          ),
          SizedBox(height: 20),
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
                  return theme.textTheme.bodyMedium!;
                }
                return theme.textTheme.bodyMedium!;
              }),
              padding: WidgetStatePropertyAll(const EdgeInsets.symmetric(horizontal: 30)),
            ),
            segments: [
              ButtonSegment(value: 0, label: Center(child: Text('Friends'),)),
              ButtonSegment(value: 1, label: Center(child: Text('Users'),)),
            ],
            selected: {_selectedIndex},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _selectedIndex = newSelection.first;
              });
            },
            showSelectedIcon: false,
          ),
          SizedBox(height: 20),
          _selectedIndex == 0
              ? FriendsListView()
              : UsersListView(),
        ],
      ),
    );
  }
}