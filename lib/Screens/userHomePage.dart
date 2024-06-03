import 'package:blindapp/Screens/loginPage.dart';
import 'package:blindapp/Screens/userVideoCallPage.dart';
import 'package:blindapp/components/circular_button.dart';
import 'package:blindapp/Screens/ai_camera.dart';
import 'package:flutter/material.dart';
import 'package:blindapp/Screens/profile.dart';
import 'package:flutter/widgets.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'Home',
            ),
            const Spacer(), // Spacer widget to push the IconButton to the right
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Implement hamburger menu functionality
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/personicon.jpg',
                width: 200,
                height: 200,
              ),
            ),
            const Center(
              child: Text(
                "Call for Volunteer",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Throne'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Need Assistance? Get in touch with a volunteer now!",
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularButton(
                        icon: const Icon(Icons.call),
                        onPressedButton: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VideoCallScreen(
                                // isUser: true,
                              ),
                            ),
                          );
                        },
                        // onPressedButton: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => VideoCallScreen()),
                        //   );
                        // },
                      ),
                      CircularButton(
                        icon: const Icon(Icons.camera),
                        onPressedButton: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraScreen(),
                            ),
                          );
                        },
                      ),
                      CircularButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressedButton: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "\t\t\t\tCall\nVolunteer",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("\t\t\tBrowse\n\t\tServices",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "\t\t\t\t\t\t\t\t\tUse\n\t\t\t\t\t\tAI Camera",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    height: 20, // Thickness of the line
                    thickness: 1, // Height of the line
                    color: Colors.grey.shade300, // Color of the line
                  ),
                  Divider(
                    height: 20, // Thickness of the line
                    thickness: 2, // Height of the line
                    color: Colors.grey.shade300, // Color of the line
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey.shade300,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("FAQ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()));
                        },
                        child: Text(
                          "Profile",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  fixedSize: const Size(300, 50),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: <Widget>[
          TextButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              _logoutAndRedirect(context);
            },
          ),
        ],
      );
    },
  );
}

void _logoutAndRedirect(BuildContext context) {
  // Perform logout logic here, e.g., clear user session

  // Navigate to the sign-in page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}
