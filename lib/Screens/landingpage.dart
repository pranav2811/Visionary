import 'package:flutter/material.dart';
import 'package:blindapp/Screens/login_page.dart';
import 'package:blindapp/Screens/user_assistance.dart';
import 'package:blindapp/Screens/volunteer_signup.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 100.0, left: 10.0),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.45,
                child: Image.asset(
                  'assets/images/landing.jpeg',
                  fit: BoxFit.fill,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle "I Need Assistance" button press
                  //route to user_assistance.dart
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserSignup()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, //Color(0xffEE7B23),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'I Need Assistance',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Handle "I Am Here to Volunteer" button press
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VolunterSignup()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, //Color(0xffEE7B23),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'I Am Here to Volunteer',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: const Text.rich(
                  TextSpan(text: 'Already have an account? ', children: [
                    TextSpan(
                      text: 'SignIn',
                      style:
                          TextStyle(color: Colors.blue), //Color(0xffEE7B23)),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
