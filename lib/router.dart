import 'package:final_thesis_app/views/user/authentication_view.dart';
import 'package:final_thesis_app/views/user/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
    routes: <RouteBase>[
        GoRoute(
            name: 'Home',
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
                return const AuthenticationView();
            },
        ),
        GoRoute(
            name: 'Register',
            path: '/register',
            builder: (BuildContext context, GoRouterState state) {
                return const RegisterView();
            },
        ),
    ]
);