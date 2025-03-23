import 'dart:developer';

import 'package:final_thesis_app/app/typedefs/e_role.dart';
import 'package:final_thesis_app/app/typedefs/e_sorting_order.dart';
import 'package:final_thesis_app/app/typedefs/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../configurations/strings.dart';
import '../../../../data/domain/user.dart';
import '../../../view_models/widgets/user/user_search_view_model.dart';


class UserSearch extends ConsumerStatefulWidget {
  const UserSearch({
    super.key,
    required this.onSearch,
    required this.onFlash,
    required this.userId,
  });

  final Function((List<User>?, int page)? searchResult) onSearch;
  final Function(bool flash) onFlash;
  final Id userId;

  @override
  ConsumerState<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends ConsumerState<UserSearch> {
  late final TextEditingController _searchController;
  ESortingOrder _nameSorting = ESortingOrder.none;
  ERole _roleFiltering = ERole.none;
  bool _isInUse = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final searchState = ref.watch(userSearchViewModelProvider);
    final searchNotifier = ref.read(userSearchViewModelProvider.notifier);

    ref.listen(userSearchViewModelProvider, (previous, next) {
      if (next is AsyncData<List<User>?>) {
        widget.onSearch((next.value, selectedIndex));
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  style: TextStyle(
                    fontSize: 20,
                    height: 0.5,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: Strings.search,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await searchNotifier.searchUsers(
                    query: _searchController.text,
                    selectedIndex: selectedIndex,
                    userId: widget.userId,
                    role: _roleFiltering,
                    sortingOrder: _nameSorting,
                  );

                  setState(() {
                    _isInUse = true;
                  });
                },
                icon: const Icon(Icons.search, size: 40),
              ),
              _isInUse
                  ? IconButton(
                onPressed: () {
                  searchNotifier.clearSearch();
                  widget.onFlash(true);

                  setState(() {
                    _isInUse = false;
                    _nameSorting = ESortingOrder.none;
                  });
                },
                icon: const Icon(Icons.cancel_outlined, size: 40),
              )
                  : const SizedBox(width: 0),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  setState(() {
                    _isInUse = _nameSorting.next() != ESortingOrder.none ||
                        _roleFiltering != ERole.none;
                    _nameSorting = _nameSorting.next();
                  });
                },
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.abc_outlined, size: 40),
                    switch (_nameSorting) {
                      ESortingOrder.none => const Icon(Icons.cancel_outlined, size: 40),
                      ESortingOrder.ascending =>
                      const Icon(Icons.arrow_circle_up_sharp, size: 40, color: Colors.greenAccent),
                      ESortingOrder.descending =>
                      const Icon(Icons.arrow_circle_down_sharp, size: 40, color: Colors.redAccent),
                    }
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    _isInUse = _roleFiltering.next() != ERole.none ||
                        _nameSorting != ESortingOrder.none;
                    _roleFiltering = _roleFiltering.next();
                  });
                },
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_circle_outlined, size: 40),
                    switch (_roleFiltering) {
                      ERole.none => const Icon(Icons.cancel_outlined, size: 40),
                      ERole.coach =>
                      const Icon(Icons.man, size: 40, color: Colors.greenAccent),
                      ERole.athlete =>
                      const Icon(Icons.directions_run_outlined, size: 40, color: Colors.redAccent),
                    }
                  ],
                ),
              ),
            ],
          ),
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
              padding: WidgetStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            segments: const [
              ButtonSegment(value: 0, label: Center(child: Text('Friends'))),
              ButtonSegment(value: 1, label: Center(child: Text('Users'))),
              ButtonSegment(value: 2, label: Center(child: Text('Requests'))),
            ],
            selected: {selectedIndex},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                selectedIndex = newSelection.first;
              });
            },
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }
}
