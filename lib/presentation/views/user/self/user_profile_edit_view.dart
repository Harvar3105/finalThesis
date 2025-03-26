import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../configurations/app_colours.dart';
import '../../../../configurations/strings.dart';
import '../../../../data/domain/user.dart';
import '../../widgets/navigation/custom_app_bar.dart';
import '../../widgets/user/user_avatar.dart';

class UserProfileEditView extends ConsumerWidget {
  const UserProfileEditView({super.key, required this.user});
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

    var fieldDecoration = BoxDecoration(
      color: AppColors.profileButtons,
      borderRadius: BorderRadius.circular(30)
    );

    fieldText(String text) {
      return Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        softWrap: true,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: theme.colorScheme.surface
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: UserAvatar(url: user.avatarUrl, radius: 60),
                ),
                Column(
                  children: [
                    SizedBox(height: 5.0),
                    Container(
                      width: 250,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: fieldDecoration,
                      child: fieldText('${user.firstName} ${user.lastName}'),
                    ),
                    SizedBox(height: 3.0),
                    Container(
                      width: 250,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: fieldDecoration,
                      child: fieldText(user.phoneNumber ?? 'No phone number'),
                    ),
                    SizedBox(height: 3.0),
                    Container(
                      width: 250,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: fieldDecoration,
                      child: fieldText(user.email),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 100,
              decoration: fieldDecoration,
              child: fieldText(user.aboutMe ?? 'No information about user')
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.push('/change-name-and-photo', extra: user);
              },
              style: buttonsStyle,
              child: Text(Strings.changeNameAndPhoto, style: buttonsTextStyle,),
            ),
            const SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                context.push('/change-email', extra: user);
              },
              style: buttonsStyle,
              child: Text(Strings.changeEmail, style: buttonsTextStyle),
            ),
            const SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                context.push('/change-password', extra: user);
              },
              style: buttonsStyle,
              child: Text(Strings.changePassword, style: buttonsTextStyle,),
            ),
          ],
        ),
      ),
    );
  }
}