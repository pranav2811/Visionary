// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  String? imageUrl;
  bool showEditIcon = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final volunteerDoc = await FirebaseFirestore.instance
          .collection('volunteers')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          imageUrl = userDoc.data()?['imageUrl'];
          nameController.text = userDoc.data()?['name'] ?? '';
          emailController.text = userDoc.data()?['email'] ?? '';
          phoneController.text = userDoc.data()?['phone'] ?? '';
        });
      } else if (volunteerDoc.exists) {
        setState(() {
          imageUrl = volunteerDoc.data()?['imageUrl'];
          nameController.text = volunteerDoc.data()?['name'] ?? '';
          emailController.text = volunteerDoc.data()?['email'] ?? '';
          phoneController.text = volunteerDoc.data()?['phone'] ?? '';
        });
      } else {
        setState(() {
          imageUrl = null;
          nameController.text = user!.displayName ?? '';
          emailController.text = user!.email ?? '';
          phoneController.text = '';
        });
      }
    }
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final uid = user!.uid;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');
      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      if (downloadUrl.isNotEmpty) {
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final volunteerDoc = await FirebaseFirestore.instance
            .collection('volunteers')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'imageUrl': downloadUrl,
          });
        } else if (volunteerDoc.exists) {
          await FirebaseFirestore.instance
              .collection('volunteers')
              .doc(uid)
              .update({
            'imageUrl': downloadUrl,
          });
        }

        setState(() {
          imageUrl = downloadUrl;
        });
      }
    }
  }

  Future<void> updateUserData() async {
    final uid = user!.uid;
    final String newName = nameController.text;
    final String newEmail = emailController.text;
    final String newPhone = phoneController.text;
    final String newPassword = passwordController.text;

    // Check if user or volunteer
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final volunteerDoc = await FirebaseFirestore.instance
        .collection('volunteers')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      // Update Firestore user data
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
        'role': 'Registered User'
      });
    } else if (volunteerDoc.exists) {
      // Update Firestore volunteer data
      await FirebaseFirestore.instance
          .collection('volunteers')
          .doc(uid)
          .update({
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
      });
    }

    // Update Firebase Authentication email and password
    if (newEmail.isNotEmpty && newPassword.isNotEmpty) {
      try {
        if (user!.isAnonymous) {
          // Link the anonymous account with email and password
          final credential = EmailAuthProvider.credential(
              email: newEmail, password: newPassword);
          await user!.linkWithCredential(credential);
        } else {
          // Update the email and password for non-anonymous users
          await user!.updateEmail(newEmail);
          await user!.updatePassword(newPassword);
        }
        await FirebaseAuth.instance.currentUser?.reload();
        user = FirebaseAuth.instance.currentUser;

        Fluttertoast.showToast(
          msg: 'Profile updated successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } catch (e) {
        // Handle errors if any
        print("Error updating email/password: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showEditIcon = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showEditIcon = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : const AssetImage('assets/images/personicon.jpg')
                                as ImageProvider,
                      ),
                      if (showEditIcon)
                        GestureDetector(
                          onTap: uploadImage,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        fixedSize: const Size(300, 50),
                      ),
                      child: const Text(
                        "Update Information",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
