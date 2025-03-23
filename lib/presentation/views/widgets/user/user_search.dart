import 'dart:developer';

import 'package:final_thesis_app/app/typedefs/e_role.dart';
import 'package:final_thesis_app/app/typedefs/e_sorting_order.dart';
import 'package:final_thesis_app/app/typedefs/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final ESortingOrder _nameSorting = ESortingOrder.none;
  final ERole _roleFiltering = ERole.none;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final userSearchState = ref.watch(userSearchViewModelProvider);
    final userSearchVM = ref.read(userSearchViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  style: TextStyle(fontSize: 20, height: 0.5, color: theme.colorScheme.onPrimary),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              IconButton(
                onPressed: () {
                  userSearchVM.searchUsers(
                    query: _searchController.text,
                    selectedIndex: selectedIndex,
                    userId: widget.userId,
                    role: _roleFiltering,
                    sortingOrder: _nameSorting,
                  );
                },
                icon: const Icon(Icons.search, size: 40),
              ),
            ],
          ),
          userSearchState.when(
            data: (users) {
              return users.isEmpty
                  ? const Text("No users found.")
                  : Column(
                children: users.map((user) => Text(user.firstName)).toList(),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text("Error: $error"),
          ),
        ],
      ),
    );
  }
}
