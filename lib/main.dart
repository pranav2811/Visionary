import 'package:flutter/material.dart';
import 'package:blindapp/Screens/landingpage.dart'; // Import your landing page file here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlindApp',
      theme: ThemeData(
        // Define your app's theme here
      ),
      // Set the initialRoute to your landing page route
      initialRoute: '/landing', 
      // Define the routes for your app
      routes: {
        '/landing': (context) => LandingPage(), // Landing page route
        // Add other routes if needed
      },
    );
  }
}
