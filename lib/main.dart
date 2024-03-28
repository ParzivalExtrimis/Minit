import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minit/hive/box.dart';
import 'package:minit/screens/home.dart';
import 'package:minit/services/notification_service.dart';
import 'package:minit/themes/timePickerTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // sets up hive and opens/exposes box ( db )
  await BoxInterface.initializeHive();
  //await wipeBox();

  // sets up notification listeners
  await NotificationService.init();

  // starts bakground service
  //await BackgroundService.init();

  runApp(const ProviderScope(child: App()));
}

Future<void> wipeBox() async {
  await BoxInterface.taskBox?.clear();
}

const kColor = Color.fromARGB(255, 248, 163, 157);

class App extends StatefulWidget {
  const App({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.hidden) {
      log('AppLifecycleState.hidden', name: 'main');
    }
    if (appState == AppLifecycleState.inactive) {
      log('AppLifecycleState.inactive', name: 'main');
    }
    if (appState == AppLifecycleState.paused) {
      log('AppLifecycleState.paused', name: 'main');
    }
    if (appState == AppLifecycleState.resumed) {
      log('AppLifecycleState.resumed', name: 'main');
    }

    //TODO: LifeCycle can't be monitoreda t countDown level
    // figure out a way to use callbacks here and update remaining seconds
    if (appState == AppLifecycleState.detached) {
      log('AppLifecycleState.detached');
      // ref
      //     .read(taskListProvider.notifier)
      //     .pauseTask(widget.task, _remainingSeconds);
    }
  }

  final ThemeData appTheme = ThemeData(
    timePickerTheme: customTimePickerTheme,
    appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true,
    ),
    textTheme: GoogleFonts.rubikTextTheme(),
    colorScheme: ColorScheme.fromSeed(seedColor: kColor),
    useMaterial3: true,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      title: 'Minit',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
