import 'package:final_thesis_app/views/calendar/calendar_view.dart';
import 'package:final_thesis_app/views/main_view.dart';
import 'package:final_thesis_app/views/user/login_view.dart';
import 'package:final_thesis_app/views/user/register_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app/services/authentication/providers/login_state.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    redirect: (context, state) {
      if (!isLoggedIn && state.fullPath != '/login' && state.fullPath != '/register') {
        return '/Login';
      }
      return null;
    },
    routes: [
      GoRoute(
        name: 'Login',
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: 'Register',
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainView(innedWidget: child),
        routes: [
          GoRoute(
            name: 'Home',
            path: '/',
            builder: (context, state) => const CalendarView(),
          ),
        ],
      ),
    ],
  );
}
);
