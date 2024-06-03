import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    if (_client == null) return Center(child: CircularProgressIndicator());

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





// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_uikit/agora_uikit.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({super.key});

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   final AgoraClient _client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//         appId: '5a1eb9ed6ab34eada8cbd564a0f5732c',
//         channelName: 'testing',
//         tempToken:
//             '007eJxTYGg5npXpKNz/8oSK9HWf9de2/j9zOvrv0bkXtgfaTk80/7RTgcE00TA1yTI1xSwxydgkNTEl0SI5KcXUzCTRIM3U3NgoOUk8Lq0hkJEhe/1tBkYoBPHZGUpSi0sy89IZGADFqyRT'),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//   }

//   Future<void> _initAgora() async {
//     await _client.initialize();
//     await _client.engine.setCameraCapturerConfiguration(
//       const CameraCapturerConfiguration(
//         cameraDirection: CameraDirection.cameraRear,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(
//                 client: _client,
//                 layoutType: Layout
//                     .oneToOne, // This may need to be adjusted if available layouts do not meet your requirements
//                 // enableToggleLocalVideoSize: true,
//                 showNumberOfUsers: false,
//               ),
//               Positioned(
//                 bottom: 20,
//                 right: 20,
//                 left: 20,
//                 child: AgoraVideoButtons(
//                   client: _client,
//                   enabledButtons: const [
//                     BuiltInButtons.switchCamera,
//                     BuiltInButtons.callEnd,
//                     BuiltInButtons.toggleMic,
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
