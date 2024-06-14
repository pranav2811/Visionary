import 'package:blindapp/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:get/get.dart';
import 'package:blindapp/Screens/userHomePage.dart';
import 'package:blindapp/Screens/volunteerHomePage.dart';
import 'package:blindapp/Screens/landingPage.dart';
import 'dart:async';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BlindApp',
      theme: ThemeData(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const LandingPage();
            } else {
              // Check role from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    if (userSnapshot.data?.exists ?? false) {
                      // User exists in 'users' collection
                      return UserHomePage();
                    } else {
                      // Check in 'volunteers' collection
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('volunteers')
                            .doc(user.uid)
                            .get(),
                        builder: (context, volunteerSnapshot) {
                          if (volunteerSnapshot.connectionState ==
                              ConnectionState.done) {
                            if (volunteerSnapshot.data?.exists ?? false) {
                              return const VolunteerHomePage();
                            } else {
                              return const LandingPage();
                            }
                          }
                          return const Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(child: CircularProgressIndicator()),
                          );
                        },
                      );
                    }
                  }
                  return const Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
              );
            }
          }
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
