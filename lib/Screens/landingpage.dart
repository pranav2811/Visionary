import 'package:blindapp/Screens/userHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:blindapp/Screens/loginPage.dart';
import 'package:blindapp/Screens/volunteerSignupPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeTTSAndSTT();
  }

  Future<void> _initializeTTSAndSTT() async {
    await _speak(
        "Welcome to BlindApp. Say 'Assistance' or 'Volunteer' to navigate.");
    _startListening();
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('onStatus: $status');
        if (status == 'done' || status == 'notListening') {
          _tryRestartListening();
        }
      },
      onError: (errorNotification) {
        print('onError: $errorNotification');
        if (errorNotification.errorMsg == "error_speech_timeout") {
          _tryRestartListening();
        }
      },
    );
    if (available) {
      _speech.listen(
          onResult: (result) {
            setState(() {
              _isListening = false;
              _handleCommand(result.recognizedWords.toLowerCase());
            });
          },
          listenFor: Duration(seconds: 60),
          pauseFor: Duration(seconds: 15),
          partialResults: true);
    }
  }

  void _tryRestartListening() {
    if (!_isListening) {
      // Check to ensure we're not already listening
      _isListening = true;
      _startListening();
    }
  }

  void _handleCommand(String command) {
    if (command.contains("assistance")) {
      _speak("You have opted for the assistance option");
      _registerGuest();
    } else if (command.contains("volunteer")) {
      _speak("I am here to volunteer selected.");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VolunterSignup()));
    } else {
      _speak("Command not recognized. Please say 'Assistance' or 'Volunteer'.");
    }
  }

  Future<void> _registerGuest() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {
        DocumentReference counterRef =
            _firestore.collection('metadata').doc('guestCounter');
        DocumentSnapshot counterSnapshot = await counterRef.get();
        int guestCount = 0;
        if (counterSnapshot.exists) {
          guestCount = counterSnapshot['count'] as int;
        }
        guestCount += 1;
        await counterRef.set({'count': guestCount});
        String guestName = 'Guest$guestCount';
        await _firestore.collection('users').doc(user.uid).set({
          'name': guestName,
          'email': 'guest@blindapp.com',
          'phone': 'N/A',
          'role': 'guestuser',
        });
        _speak("Signed in as Guest User");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const UserHome()));
      }
    } catch (e) {
      print("Failed to register guest user: $e");
      _speak("Failed to sign in as Guest User. Please try again.");
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _speech.cancel();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 100.0, left: 10.0),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _startListening,
                child: Container(
                  width: width,
                  height: height * 0.45,
                  child: Image.asset(
                    'assets/images/landing.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                onPressed: () {
                  _speak(
                      "I need assistance button pressed. Loading assistance page.");
                  _registerGuest();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'I Need Assistance',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _speak(
                      "I am here to volunteer button pressed. Loading volunteer page.");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VolunterSignup()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'I Am Here to Volunteer',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  _speak("Navigating to sign in page.");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: const Text.rich(
                  TextSpan(text: 'Already have an account? ', children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
