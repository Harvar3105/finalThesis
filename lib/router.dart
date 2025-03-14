import 'package:final_thesis_app/views/calendar/calendar_view.dart';
import 'package:final_thesis_app/views/main_view.dart';
import 'package:final_thesis_app/views/user/login_view.dart';
import 'package:final_thesis_app/views/user/register_view.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    if (!isLoggedIn && state.fullPath != '/' && state.fullPath != '/register') {
      return '/Login';
    }

    return null;
  },
  routes: [
    GoRoute(
      name: 'Login',
      path: '/Login',
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
