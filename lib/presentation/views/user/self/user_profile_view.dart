import 'dart:developer';

import 'package:final_thesis_app/presentation/view_models/user/self/user_profile_view_model.dart';
import 'package:final_thesis_app/presentation/views/calendar/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../configurations/app_colours.dart';
import '../../../../data/domain/user.dart';
import '../../widgets/animations/animation_with_text.dart';
import '../../widgets/animations/error_animation.dart';
import '../../widgets/animations/loading/loading_animation.dart';
import '../../widgets/user/user_avatar.dart';


class UserProfileView extends ConsumerStatefulWidget {
  const UserProfileView({super.key, this.user});
  final User? user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends ConsumerState<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final userAsync = ref.watch(UserProfileViewModelProvider(selectedUser: widget.user));

    return userAsync.when(
      data: (user) {
        final vm = ref.watch(UserProfileViewModelProvider(selectedUser: widget.user).notifier);
        return _buildView(vm, theme, user);
      },
      loading: () => const AnimationWithText(
          animation: LoadingAnimationView(), text: 'Loading friends...'),
      error: (error, stackTrace) {
        log('UserProfileView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );
  }

  Widget _buildView(UserProfileViewModel vm, ThemeData theme, User? selectedUser) {
    final user = selectedUser ?? vm.currentUser!;
    final isCurrentUser = vm.isCurrentUser;

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

    return SingleChildScrollView(
      child: Container(
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
            Text("Events together so on: ${vm.processedEventsCount}"),
            const SizedBox(height: 24),
            Container(
                height: 100,
                decoration: fieldDecoration,
                child: fieldText(user.aboutMe ?? 'No information about user')
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 500,
              child: CalendarView(user: user, isProfileView: true,),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
