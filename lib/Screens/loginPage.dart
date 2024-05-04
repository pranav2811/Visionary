import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blindapp/Screens/forgotPasswordScreen.dart';
import 'package:blindapp/Screens/landingPage.dart';
import 'package:blindapp/components/my_button.dart';
import 'package:blindapp/components/my_textfield.dart';
import 'package:blindapp/utils/loginController.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/landing.jpeg',
              height: 350,
              width: 350,
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            MyTextField(
              textFieldHeight: 60,
              textFieldWidth: 350,
              controller: controller.emailController,
              hintText: 'username',
              obsecureText: false,
              prefixIconData: Icons.person,
              prefixIconColor: Colors.blue,
            ),
            const SizedBox(height: 10),
            MyTextField(
              textFieldHeight: 60,
              textFieldWidth: 350,
              controller: controller.passwordController,
              hintText: 'Password',
              obsecureText: true,
              prefixIconData: Icons.lock,
              prefixIconColor: Colors.blue,
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            Obx(() => MyButton(
                  buttonText: controller.isLoading.value ? 'Logging In...' : 'Login',
                  onPressedAsync: () => controller.signInWithEmailAndPassword(context),
                )),
            const SizedBox(height: 20),
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
