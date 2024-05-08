import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:blindapp/utils/channelManagement.dart'; // Ensure this path is correct

class VideoCallScreen extends StatefulWidget {
  final bool isUser;
  const VideoCallScreen({super.key, required this.isUser});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late AgoraClient _client;
  late final ChannelService _channelService;
  String _channelId = '';
  bool _isInitialized = false; // Flag to track if Agora is ready

  @override
  void initState() {
    super.initState();
    _channelService = ChannelService();
    _initChannel();
  }

  Future<void> _initChannel() async {
    try {
      _channelId = await _channelService.getOrCreateChannel(widget.isUser);
      print('Joined Channel ID: $_channelId');
      _client = AgoraClient(
        // Recreate the AgoraClient here with the fetched channel ID
        agoraConnectionData: AgoraConnectionData(
          appId: '5a1eb9ed6ab34eada8cbd564a0f5732c',
          channelName: _channelId, // Set the dynamically obtained channel name
          tempToken: 'Your_temp_token_here',
        ),
      );
      await _initAgora();
      setState(() {
        _isInitialized = true; // Set the flag to true after initialization
      });
      print('Agora Initialization completed');
    } catch (e) {
      print('Error occurred while initializing Agora: $e');
    }
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
  void dispose() {
    super.dispose();
    if (_isInitialized) {
      _channelService.leaveChannel(_channelId, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: _isInitialized
              ? Stack(
                  // Ensure components are loaded only if initialized
                  children: [
                    AgoraVideoViewer(
                      client: _client,
                      layoutType: Layout.oneToOne,
                      showNumberOfUsers: false,
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
                )
              : Center(
                  child:
                      CircularProgressIndicator()), // Show loading indicator until initialized
        ),
      ),
    );
  }
}
