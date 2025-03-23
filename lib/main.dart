import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/services/push/push_notifications_service.dart';
import 'app/theme/theme.dart';
import 'configurations/strings.dart';
import 'firebase_options.dart';
import 'package:final_thesis_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final container = ProviderContainer();
  await container.read(pushNotificationsServiceProvider.future);

  runApp(
    ProviderScope(
      parent: container,
      child: const MyApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Background message received: ${message.messageId}');
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();

    bool themeIsDark = prefs.getBool("isDark") ?? false;
    ref.read(themeProvider.notifier).setDarkTheme(themeIsDark);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp.router(
          title: Strings.main,
          theme: theme,
          routerConfig: router,
        );
      },
    );
  }
}
