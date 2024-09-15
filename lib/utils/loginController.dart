import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blindapp/Screens/userHomePage.dart';
import 'package:blindapp/Screens/volunteerHomePage.dart';
import 'package:blindapp/firebase_messaging_service.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Initialize Firebase Messaging Service
        await _firebaseMessagingService.initialize();

        // Get the FCM token
        String? token = await _firebaseMessagingService.getToken();

        // Check if the user is a volunteer and update Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        DocumentSnapshot volunteerSnapshot = await FirebaseFirestore.instance.collection('volunteers').doc(user.uid).get();

        if (volunteerSnapshot.exists) {
          // Update FCM token for volunteer
          await FirebaseFirestore.instance.collection('volunteers').doc(user.uid).update({
            'fcmToken': token,
          });

          // Navigate to volunteer home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VolunteerHomePage()),
          );
        } else if (userSnapshot.exists) {
          // Update FCM token for user
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'fcmToken': token,
          });

          // Navigate to user home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserHomePage()),
          );
        } else {
          // Handle case where user is not found in either collection
          print('User not found in users or volunteers collection');
        }
      }
    } catch (e) {
      // Handle errors
      print('Login failed: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
