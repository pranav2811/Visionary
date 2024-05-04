import 'package:blindapp/Screens/userHomePage.dart';
import 'package:blindapp/Screens/volunteerHomePage.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("successful login");
      checkUserRole(userCredential.user!.email!, context);
    } catch (e) {
      print('Sign-in Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to sign in. Please check your credentials.')));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkUserRole(String email, BuildContext context) async {
    var volunteer = await firestore
        .collection('volunteers')
        .where('email', isEqualTo: email)
        .get();

    if (volunteer.docs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VolunteerHomePage()),
      );
      return;
    }

    var user = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (user.docs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserHome()),
      );
      return;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
