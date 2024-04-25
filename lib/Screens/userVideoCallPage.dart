import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
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
    await _client.engine.setCameraCapturerConfiguration(
      const CameraCapturerConfiguration(
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
                layoutType: Layout
                    .floating, // This may need to be adjusted if available layouts do not meet your requirements
                showNumberOfUsers: false,
                // To enforce that the remote user has the bigger picture,
                // you may need to customize the widget further or handle it via state management.
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: AgoraVideoButtons(
                  client: _client,
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
