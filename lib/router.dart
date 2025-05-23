import 'dart:developer';

import 'package:final_thesis_app/presentation/view_models/authentication/other_providers/login_state.dart';
import 'package:final_thesis_app/presentation/views/calendar/calendar_view.dart';
import 'package:final_thesis_app/presentation/views/chat/chat_list_view.dart';
import 'package:final_thesis_app/presentation/views/chat/chat_view.dart';
import 'package:final_thesis_app/presentation/views/event/event_create_update_view.dart';
import 'package:final_thesis_app/presentation/views/event/event_view.dart';
import 'package:final_thesis_app/presentation/views/main_view.dart';
import 'package:final_thesis_app/presentation/views/user/friends_view.dart';
import 'package:final_thesis_app/presentation/views/user/self/change_email_view.dart';
import 'package:final_thesis_app/presentation/views/user/self/change_name_and_photo_view.dart';
import 'package:final_thesis_app/presentation/views/user/self/change_password_view.dart';
import 'package:final_thesis_app/presentation/views/user/self/login_view.dart';
import 'package:final_thesis_app/presentation/views/user/self/register_view.dart';
import 'package:final_thesis_app/presentation/views/user/self/user_profile_edit_view.dart';
import 'package:final_thesis_app/presentation/views/user/self/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'configurations/strings.dart';
import 'data/domain/chat.dart';
import 'data/domain/event.dart';
import 'data/domain/user.dart';

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
        return '/login';
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
          final user = state.extra as User;
          return UserProfileEditView(user: user);
        },
      ),
      GoRoute(
        name: Strings.changeEmail,
        path: '/change-email',
        builder: (BuildContext context, GoRouterState state) {
          return const ChangeEmailView();
        },
      ),
      GoRoute(
        name: Strings.changePassword,
        path: '/change-password',
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordView();
        },
      ),
      GoRoute(
        name: Strings.changeNameAndPhoto,
        path: '/change-name-and-photo',
        builder: (BuildContext context, GoRouterState state) {
          final user = state.extra as User;
          return ChangeNamePhotoView(user: user,);
        },
      ),
      GoRoute(
        name: Strings.addEvent,
        path: '/create-update-event',
        builder: (BuildContext context, GoRouterState state) {
          // log(state.extra.toString());
          Event? eventOrNull;
          var isCounterOffer = false;

          if (state.extra != null) {
            final data = state.extra as List<dynamic>;
            eventOrNull = data[0] is Event ? data[0] as Event : null;
            isCounterOffer = data[1] is bool ? data[1] as bool : false;
          }

          // log("Event: $eventOrNull, isCounterOffer: $isCounterOffer");
          return EventCreateUpdateView(editingEvent: eventOrNull, isCounterOffer: isCounterOffer);
        },
      ),
      GoRoute(
        name: Strings.chat,
        path: '/chat',
        builder: (context, state) {
          var chat = state.extra as Chat;
          return ChatView(chat: chat,);
        }
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainView(innedWidget: child),
        routes: [
          GoRoute(
            name: Strings.home,
            path: '/',
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final disableAnimation = extra?['disableAnimation'] == true;
              if (disableAnimation) {
                return MaterialPage(child: const CalendarView());
              } else {
                return NoTransitionPage(child: const CalendarView());
              }
            },
          ),
          // GoRoute(
          //   name: Strings.dayView,
          //   path: '/day-view',
          //   pageBuilder: (context, state) => NoTransitionPage(
          //     child: DayViewCalendar(selectedDay: state.extra != null ? state.extra as DateTime : null),
          //   ),
          // ),
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
              log("User: ${user.firstName} ${user.lastName}");
              return UserProfileView(user: user);
            }
          ),
          GoRoute(
            name: Strings.eventView,
            path: '/event-view',
            builder: (context, state) {
              log(state.extra.toString());
              final data = state.extra as List<dynamic>;

              final event = data[0] as Event;
              final isOverlapping = data[1] as bool;
              return EventView(event: event, isOverlapping: isOverlapping);
            }
          ),
          GoRoute(
            name: Strings.chats,
            path: '/chats',
            builder: (context, state) => ChatListView(),
          ),
        ],
      ),
    ],
  );
}
);
