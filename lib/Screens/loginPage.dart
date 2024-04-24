// ignore_for_file: prefer_const_constructors

import 'package:blindapp/Screens/forgotPasswordScreen.dart';
import 'package:blindapp/Screens/landingPage.dart';
import 'package:blindapp/Screens/userHomePage.dart';
import 'package:blindapp/components/my_button.dart';
import 'package:blindapp/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print("successful login");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserHome(),
        ),
      );
    } catch (e) {
      print('Sign-in Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign in. Please check your credentials.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/landing.jpeg',
              height: 350,
              width: 350,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 37),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'Login to continue using the app',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              textFieldHeight: 60,
              textFieldWidth: 350,
              controller: emailController,
              hintText: 'username',
              obsecureText: false,
              prefixIconData: Icons.person,
              prefixIconColor: Colors.blue,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              textFieldHeight: 60,
              textFieldWidth: 350,
              controller: passwordController,
              hintText: 'Password',
              obsecureText: true,
              prefixIconData: Icons.lock,
              prefixIconColor: Colors.blue,
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                signInWithEmailAndPassword(context);
              },
              child: MyButton(
                buttonText: "Login",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LandingPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
