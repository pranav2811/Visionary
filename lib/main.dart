import 'package:blindapp/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:blindapp/Screens/landingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'dart:async';
import 'package:get/get.dart';

import 'package:flutter/services.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      name: 'blindapp',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
    firebaseAppCheck.activate(
      androidProvider: AndroidProvider.debug,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    runApp(const MyApp());
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BlindApp',
      theme: ThemeData(),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(), // Landing page route
      },
    );
  }
}
