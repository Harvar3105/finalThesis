import 'package:final_thesis_app/views/calendar/calendar_view.dart';
import 'package:final_thesis_app/views/main_view.dart';
import 'package:final_thesis_app/views/user/friends_view.dart';
import 'package:final_thesis_app/views/user/self/login_view.dart';
import 'package:final_thesis_app/views/user/self/register_view.dart';
import 'package:final_thesis_app/views/user/self/user_profile_edit_view.dart';
import 'package:final_thesis_app/views/user/self/user_profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app/models/domain/user.dart';
import 'app/services/authentication/providers/login_state.dart';
import 'configurations/strings.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      if (!isLoggedIn && state.fullPath != '/login' && state.fullPath != '/register') {
        return '/Login';
      }
      return null;
    },
    routes: [
      GoRoute(
        name: Strings.loginPage,
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: Strings.registerPage,
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        name: Strings.userProfile,
        path: '/user-profile-edit',
        builder: (context, state) {
          final user = state.extra as UserPayload;
          return UserProfileEditView(user: user.userFromPayload()!);
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainView(innedWidget: child),
        routes: [
          GoRoute(
            name: Strings.home,
            path: '/',
            builder: (context, state) => const CalendarView(),
          ),
          GoRoute(
            name: Strings.friends,
            path: '/friends',
            builder: (context, state) => const FriendsView(),
          ),
          GoRoute(
            name: Strings.profile,
            path: '/user-profile-view',
            builder: (context, state) {
              final user = state.extra as User;
              return UserProfileView(user: user);
            }
          ),
        ],
      ),
    ],
  );
}
);
