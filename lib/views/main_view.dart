import 'package:final_thesis_app/app/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/services/authentication/providers/user_id.dart';
import '../app/storage/user/user_payload_provider.dart';
import '../app/theme/theme.dart';
import '../configurations/strings.dart';



class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  UserPayload? _userPayload;
  final List<Widget> screens = [];

  @override
  Widget build(BuildContext context, ) {
    final theme = ref.watch(themeProvider);
    final userId = ref.watch(userIdProvider);

    if (userId != null) {
      ref.listen<AsyncValue<UserPayload>>(userPayloadProvider(userId), (previous, next) {
        next.when(
          data: (userInfo) => setState(() => _userPayload = userInfo),
          loading: () {},
          error: (error, stack) {
            debugPrint("Ошибка загрузки UserPayload: $error");
          },
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.main),
        actions: [
          IconButton(
            onPressed: () {
              if (userId != null) {
                context.push('/user_profile/$userId');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(Strings.notLoggedIn)),
                );
              }
            },
            //Cannot use UserAvatar widget(null operator check failed)
            icon: CircleAvatar(
              backgroundImage: _userPayload?.avatarUrl != null
                  ? NetworkImage(_userPayload!.avatarUrl!)
                  : const AssetImage('assets/images/user_icon.png') as ImageProvider,
            ),
            tooltip: Strings.profile,
          ),
        ],
      ),
      // drawer: const Menu(),
      body: Column(
      ),
    );
  }
}