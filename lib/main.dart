import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/core/Utilities/routes/routes.dart';
import 'package:template/core/Utilities/utils/utils.dart';
import 'package:template/presentation/styles/darkMode_provider.dart';
import 'package:template/presentation/styles/theme.dart';

import 'api/models/screen_params.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  bool isBackground = false;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getCurrentAppTheme();
      },
    );

    //!! This function checks if firebase database is welly setup
    runMeMate();
  }

  void getCurrentAppTheme() async {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    ref.read(themeProvider).darkTheme = isDarkMode;

    // ref.read(themeProvider).darkTheme =
    //     await ref.read(themeProvider).darkThemePreference.getTheme();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    isBackground = state == AppLifecycleState.resumed;
    if (isBackground) {
      getCurrentAppTheme();
    }
  }

  runMeMate() async {
    String name = '';

    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc('B24CXCWAzjFkbDRHVEEH')
        .get();
    logger.i(snap.data());
    name = snap.data()!['name'] ?? 'Noting';
    logger.i(name);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(themeProvider);
    final goRouter = ref.watch(goRouterProvider);
    ScreenParams.screenSize = MediaQuery.sizeOf(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(provider.darkTheme, context),
      routerConfig: goRouter,
      builder: EasyLoading.init(),
    );
  }
}
