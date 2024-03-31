// ignore_for_file: prefer_const_constructors

import 'package:blindapp/components/my_textfield.dart';
import 'package:blindapp/components/my_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
              controller: usernameController,
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
                  print("Forgot Password Clicked");
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              buttonText: "Login",
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
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
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
