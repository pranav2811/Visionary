import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: '5a1eb9ed6ab34eada8cbd564a0f5732c',
        channelName: 'testing',
        tempToken:
            '007eJxTYDA9r7H5/0sul2P32dpVWhQtQ2zUHJboSbN6stk/Pu70rkqBwTTRMDXJMjXFLDHJ2CQ1MSXRIjkpxdTMJNEgzdTc2CjZ0kQrrSGQkSG65CojIwMEgvjsDCWpxSWZeekMDAD2kx5J'),
  );

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await _client.initialize();
    await _client.engine?.setCameraCapturerConfiguration(
      CameraCapturerConfiguration(
        cameraDirection: CameraDirection.cameraRear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: _client,
                layoutType: Layout.floating,
                showNumberOfUsers: false,
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  // child: Text(
                  //   'Video Call',
                  //   style: TextStyle(color: Colors.white, fontSize: 18),
                  // ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AgoraVideoButtons(
                      client: _client,
                      enabledButtons: const [
                        BuiltInButtons.switchCamera,
                        BuiltInButtons.callEnd,
                        BuiltInButtons.toggleMic,
                      ],
                    ),
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
//             '007eJxTYFjJw8mckpr63nBmf96B2YqWTF3rmzhjZNnWLz13oTyXq1GBwTTRMDXJMjXFLDHJ2CQ1MSXRIjkpxdTMJNEgzdTc2Ch5307ltIZARoavhe8YGKEQxGdnKEktLsnMS2dgAAARnR/o'),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//   }

//   Future<void> _initAgora() async {
//     await _client.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Video Call'),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(
//                 client: _client,
//                 layoutType: Layout.floating,
//                 showNumberOfUsers: false,
//               ),
//               AgoraVideoButtons(
//                 client: _client,
//                 enabledButtons: const [
//                   BuiltInButtons.switchCamera,
//                   BuiltInButtons.callEnd,
//                   BuiltInButtons.toggleMic,
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
