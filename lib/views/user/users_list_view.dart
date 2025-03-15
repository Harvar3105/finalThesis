import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersListView extends ConsumerStatefulWidget {
  const UsersListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsersListViewState();
}

class _UsersListViewState extends ConsumerState<UsersListView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

        ],
      ),
    );
  }
}