import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:blindapp/utils/channelManagement.dart'; // Ensure this path is correct

class VolunteerVideoCallScreen extends StatefulWidget {
  final bool isUser;
  const VolunteerVideoCallScreen({super.key, required this.isUser});

  @override
  State<VolunteerVideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VolunteerVideoCallScreen> {
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
    _channelId = await _channelService.getOrCreateChannel(widget.isUser);
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
  }

  Future<void> _initAgora() async {
    await _client.initialize();
    await _client.engine.enableLocalVideo(false);
  }

  @override
  void dispose() {
    super.dispose();
    if (_isInitialized) {
      _channelService.leaveChannel(_channelId, false);
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
