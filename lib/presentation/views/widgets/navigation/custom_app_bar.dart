import 'package:final_thesis_app/app/models/dialog/dialog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/theme.dart';
import '../../../../configurations/strings.dart';
import '../../../view_models/authentication/authentication_state_model.dart';
import '../../../view_models/widgets/navigation/custom_app_bar_view_model.dart';
import '../dialogs/logout_dialog.dart';
import 'avatar_with_cpeech_bubble.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  static const forbiddenPages = [Strings.loginPage, Strings.registerPage, Strings.userProfile];


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final theme = ref.watch(themeProvider);
    final String routeName = GoRouterState.of(context).topRoute?.name ?? 'unknown';

    final userAsync = ref.watch(customAppBarViewModelProvider);

    return AppBar(
      leadingWidth: 122,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (context.canPop())
            IconButton(
              icon: Icon(Icons.arrow_back, size: 35, color: theme.iconTheme.color),
              onPressed: () => context.pop(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: themeNotifier.toggleTheme,
              icon: theme.brightness == Brightness.light
                  ? Icon(Icons.brightness_2, size: 35, color: theme.iconTheme.color)
                  : Icon(Icons.brightness_7, size: 35, color: theme.iconTheme.color),
            ),
          ),
        ],
      ),
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          routeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: !CustomAppBar.forbiddenPages.contains(routeName)
              ? userAsync.when(
            data: (user) => AvatarWithSpeechBubble(
              avatarImage: user?.avatarThumbnailUrl != null
                  ? NetworkImage(user!.avatarThumbnailUrl!)
                  : const AssetImage('assets/images/user_icon.png') as ImageProvider,
              onButton1Pressed: () async {
                final logout = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);

                if (logout) {
                  await ref.read(authenticationStateModelProvider.notifier).logOut();
                }
              },
              onButton2Pressed: () {
                context.push('/user-profile-edit', extra: user);
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Icon(Icons.error, color: theme.colorScheme.error),
          )
              : null,
        ),
      ],
    );
  }
}
