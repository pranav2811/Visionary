import 'package:blindapp/Screens/loginPage.dart';
import 'package:blindapp/Screens/userVideoCallPage.dart';
import 'package:blindapp/Screens/ai_camera.dart';
import 'package:flutter/material.dart';
import 'package:blindapp/Screens/profile.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const UserHomePage(),
    );
  }
}

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  final FlutterTts _flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeTts();
    _initializeSpeechRecognition();
  }

  void _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(
        true); // Ensure TTS completion before starting to listen
  }

  void _initializeSpeechRecognition() async {
    bool available = await _speech.initialize();
    if (available) {
      _startListeningWithPrompt();
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _startListeningWithPrompt() async {
    await _speak(
        "Listening for commands. Say 'Call volunteer', 'Help', 'Assistance' or 'Camera'.");
    _startListening();
  }

  void _startListening() {
    _speech.listen(
      onResult: (val) => setState(() {
        _speechText = val.recognizedWords.toLowerCase();
        if (_speechText.contains("call volunteer") ||
            _speechText.contains("help") ||
            _speechText.contains("assistance")) {
          _promptVolunteerConnection();
        } else if (_speechText.contains("camera")) {
          _onItemTapped(1);
          _speak("Switching to camera.");
        } else {
          _speak(
              "No valid input received. Please say 'Call volunteer', 'Help', 'Assistance' or 'Camera'.");
          _startListening();
        }
      }),
      listenFor: Duration(seconds: 10),
      pauseFor: Duration(seconds: 5),
      partialResults: false,
      onSoundLevelChange: (double level) {},
    );
  }

  void _stopListening() {
    _speech.stop();
  }

  Future<void> _promptVolunteerConnection() async {
    await _speak(
        "Would you like to connect with a volunteer? Please say yes or no.");
    _speech.listen(
      onResult: (val) => setState(() {
        _speechText = val.recognizedWords.toLowerCase();
        if (_speechText.contains("yes")) {
          _callVolunteer();
        } else if (_speechText.contains("no")) {
          _speak(
              "Okay, if you need help later, just say call volunteer or help.");
        } else {
          _speak(
              "No valid input received. Would you like to connect with a volunteer? Please say yes or no.");
          _promptVolunteerConnection();
        }
      }),
      listenFor: Duration(seconds: 10),
      pauseFor: Duration(seconds: 5),
      partialResults: false,
      onSoundLevelChange: (double level) {},
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    } else if (index == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserHomePage()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CameraScreen()));
      _speak("Switching to camera.");
    }
  }
void _callVolunteer() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Handle user not logged in
    print("User not logged in");
    return;
  }

  String userId = user.uid;
  String channelId = DateTime.now().millisecondsSinceEpoch.toString();

  await FirebaseFirestore.instance.collection('channels').doc(channelId).set({
    'channelId': channelId,
    'userId': userId,
    'isOccupied': false,
  });

  _speak("Connecting to a volunteer.");
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const VideoCallScreen()));
}


  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, size: 130),
            ),
            const SizedBox(height: 20),
            const Text(
              'Call for a volunteer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Connect with a volunteer to get assistance now!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _callVolunteer,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
              ),
              child: const Text(
                'Call a Volunteer',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _logoutAndRedirect(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _logoutAndRedirect(BuildContext context) {
    _speak("Logging out and redirecting to login page.");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
