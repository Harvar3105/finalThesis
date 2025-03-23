import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/domain/user.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => {
        context.push('/user-profile-view', extra: user)
      },
      child: ListTile(
        title: Text(user.firstName, style: theme.textTheme.bodyLarge,),
        subtitle: Text(user.email, style: theme.textTheme.bodyMedium,),
        leading: CircleAvatar(
          child: Text(user.lastName.isNotEmpty ? user.lastName[0] : '?'),
        ),
      )
    );
  }
}