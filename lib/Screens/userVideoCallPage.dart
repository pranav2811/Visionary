import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AgoraClient? _client;
  String _channelName = '';

  @override
  void initState() {
    super.initState();
    _initVideoCall();
  }

  Future<void> _initVideoCall() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // Handle user not logged in
      print("User not logged in");
      return;
    }
    String userId = user.uid;

    // Generate a unique channel ID (for simplicity, using a timestamp here)
    _channelName = DateTime.now().millisecondsSinceEpoch.toString();

    // Store the channel in Firestore
    await _firestore.collection('channels').doc(_channelName).set({
      'channelName': _channelName,
      'userId': userId, // use the actual user ID
      'isOccupied': false,
    });

    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: '855ba77811cb4d11b801101b74f3d088',
        channelName: _channelName,
        tempToken: null, // Set to null when tokens are disabled
      ),
    );

    await _client!.initialize();

    _client!.engine.setCameraCapturerConfiguration(
        const CameraCapturerConfiguration(
            cameraDirection: CameraDirection.cameraRear));

    setState(() {}); // Refresh the UI
  }

  @override
  void dispose() {
    if (_channelName.isNotEmpty) {
      _firestore.collection('channels').doc(_channelName).delete();
    }

    _client?.engine.leaveChannel();
    _client?.engine.leaveChannel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_client == null) {
      return const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: _client!,
                layoutType: Layout.oneToOne,
                showNumberOfUsers: true,
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: AgoraVideoButtons(
                  client: _client!,
                  enabledButtons: const [
                    BuiltInButtons.switchCamera,
                    BuiltInButtons.callEnd,
                    BuiltInButtons.toggleMic,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
