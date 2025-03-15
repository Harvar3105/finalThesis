import 'package:final_thesis_app/app/models/dialog/dialog_model.dart';
import 'package:final_thesis_app/app/services/authentication/authentication_service.dart';
import 'package:final_thesis_app/views/widgets/navigation/avatar_with_cpeech_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/models/domain/user.dart';
import '../../../app/services/authentication/providers/user_id.dart';
import '../../../app/storage/user/user_payload_provider.dart';
import '../../../app/theme/theme.dart';
import '../../../configurations/strings.dart';
import '../dialogs/logout_dialog.dart';

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  UserPayload? _userPayload;


  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final theme = ref.watch(themeProvider);
    final userId = ref.watch(userIdProvider);

    if (userId != null) {
      ref.listen<AsyncValue<UserPayload>>(userPayloadProvider(userId), (previous, next) {
        next.when(
          data: (payload) => setState(() => _userPayload = payload),
          loading: () {},
          error: (error, stack) {
            debugPrint("Cannot load UserPayload: $error");
          },
        );
      });
    }

    const padding = EdgeInsets.symmetric(horizontal: 10);

    return AppBar(
      // If need to change icons sizes, change also leadingWidth
      leadingWidth: 122,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (context.canPop())
            IconButton(
              icon: Icon(Icons.arrow_back, size: 35, color: theme.iconTheme.color,),
              onPressed: () => context.pop(),
            ),
          Padding(
            padding: padding,
            child: IconButton(
              onPressed: themeNotifier.toggleTheme,
              icon: theme.brightness == Brightness.light
                  ? Icon(Icons.brightness_2, size: 35, color: theme.iconTheme.color,)
                  : Icon(Icons.brightness_7, size: 35, color: theme.iconTheme.color,),
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
          GoRouterState.of(context).topRoute?.name ?? 'unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: padding,
          child: AvatarWithSpeechBubble(
            avatarImage: _userPayload?.avatarUrl != null
              ? NetworkImage(_userPayload!.avatarUrl!)
              : const AssetImage('assets/images/user_icon.png') as ImageProvider,
            onButton1Pressed: () async {
              final logout = await const LogoutDialog()
                  .present(context)
                  .then((value) => value ?? false);

              if (logout) {
                await ref.read(authenticationServiceProvider.notifier).logOut();
              }
            },
            onButton2Pressed: () {
              print('Кнопка 2 нажата');
            },
          )
        ),
      ],
    );
  }
}
