import 'package:blindapp/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/forgotpass.jpg',
              height: 350,
              width: 350,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    'Please enter the email address linked with your account!',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            MyTextField(
                controller: emailController,
                hintText: "Email Address",
                obsecureText: false,
                prefixIconData: Icons.email,
                prefixIconColor: Colors.blue,
                textFieldHeight: 60,
                textFieldWidth: 350),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50), backgroundColor: Colors.blue),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Reset link sent successfully. Check your email.'),
                          backgroundColor: Colors.green),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Failed to send reset link. Please check the email provided and try again.'),
                          backgroundColor: Colors.red),
                    );
                    String errorMessage = 'Failed to send reset link.';
                    if (error is FirebaseAuthException) {
                      switch (error.code) {
                        case 'user-not-found':
                          errorMessage = 'No user found with this email.';
                          break;
                        case 'invalid-email':
                          errorMessage = 'The email address is invalid.';
                          break;
                        default:
                          errorMessage =
                              'An unexpected error occurred. Please try again.';
                          break;
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
