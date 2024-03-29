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
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/images/landing.jpeg', fit: BoxFit.contain),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
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
              controller: passwordController,
              hintText: 'Password',
              obsecureText: true,
              prefixIconData: Icons.lock,
              prefixIconColor: Colors.blue,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const MyButton(),
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
