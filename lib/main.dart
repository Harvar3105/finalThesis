import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_api_keys.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/theme/theme.dart';
import 'configurations/strings.dart';
import 'configurations/firebase/firebase_options.dart';
import 'package:final_thesis_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    log('Error initializing Firebase Messaging. Is web permission blocked?: $e');
  }

  //TODO: Register all projects in firebase AppCheck when app is finished
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider(FirebaseApiKeys.reCaptchaSiteKey),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  runApp(
    ProviderScope(
      child: const RestartableApp(), // Contains MyApp and handles widgets restart
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Background message received: ${message.messageId}');
}

// App and its state
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

// App restarter
class RestartableApp extends StatefulWidget {
  const RestartableApp({super.key});

  @override
  State<RestartableApp> createState() => _RestartableAppState();

  static late void Function() restartApp;
}

class _RestartableAppState extends State<RestartableApp> {
  Key _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    RestartableApp.restartApp = _restartApp;
  }

  void _restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: const MyApp(),
    );
  }
}
