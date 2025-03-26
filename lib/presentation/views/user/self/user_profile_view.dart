import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../configurations/app_colours.dart';
import '../../../../data/domain/user.dart';
import '../../widgets/user/user_avatar.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    var buttonsTextStyle = TextStyle(
      color: theme.colorScheme.onSurface,
      fontSize: 18,
      height: 2,
    );

    var buttonsStyle = TextButton.styleFrom(
      backgroundColor: AppColors.profileButtons,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: UserAvatar(url: user.avatarUrl, radius: 100),
        ),
        const SizedBox(height: 24),

        DecoratedBox(
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${user.firstName} ${user.lastName}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Email: ${user.email}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}