import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/services/push/PushNotificationService.dart';
import 'app/theme/theme.dart';
import 'configurations/strings.dart';
import 'firebase_options.dart';
import 'package:final_thesis_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await PushNotificationService().initialize();


  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Background message received: ${message.messageId}');
}

class MyApp extends ConsumerWidget{
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<void>(
      future: _initializeTheme(ref),
      builder: (context, snapshot) {
        final theme = ref.watch(themeProvider);
        return MaterialApp.router(
          title: Strings.main,
          theme: theme,
          routerConfig: router,
        );
      },
    );
  }

  Future<void> _initializeTheme(WidgetRef ref) async {
    var prefs = await SharedPreferences.getInstance();
    bool themeIsDark = prefs.getBool("isDark") ?? false;
    ref.read(themeProvider.notifier).setDarkTheme(themeIsDark);
  }
}