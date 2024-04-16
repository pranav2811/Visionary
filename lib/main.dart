import 'package:blindapp/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:blindapp/Screens/landingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'dart:async';

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
    firebaseAppCheck
        .getToken()
        .then((value) => debugPrint("APP CHECK: $value"));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    runApp(MyApp());
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlindApp',
      theme: ThemeData(),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => LandingPage(), // Landing page route
      },
    );
  }
}
