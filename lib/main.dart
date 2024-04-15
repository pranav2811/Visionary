import 'package:flutter/material.dart';
import 'package:blindapp/Screens/landingPage.dart'; // Import your landing page file here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlindApp',
      theme: ThemeData(
      ),
      initialRoute: '/landing', 
      
      routes: {
        '/landing': (context) => LandingPage(), // Landing page route
      },
    );
  }
}
