import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class VolunteerVideoCallScreen extends StatefulWidget {
  const VolunteerVideoCallScreen({super.key});

  @override
  State<VolunteerVideoCallScreen> createState() =>
      _VolunteerVideoCallScreenState();
}

class _VolunteerVideoCallScreenState extends State<VolunteerVideoCallScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AgoraClient? _client;
  String _channelName = '';

  @override
  void initState() {
    super.initState();
    _initVolunteerCall();
  }

  Future<void> _initVolunteerCall() async {
    // Fetch the first available channel from Firestore
    QuerySnapshot querySnapshot = await _firestore
        .collection('channels')
        .where('isOccupied', isEqualTo: false)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot channelDoc = querySnapshot.docs.first;
      _channelName = channelDoc['channelName'];

      // Mark the channel as occupied
      await _firestore
          .collection('channels')
          .doc(_channelName)
          .update({'isOccupied': true});

      _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: '855ba77811cb4d11b801101b74f3d088',
          channelName: _channelName,
          tempToken: null, // Set to null when tokens are disabled
        ),
      );

      await _client!.initialize();

      // Disable local video
      await _client!.engine.enableLocalVideo(false);

      setState(() {}); // Refresh the UI
    } else {
      // Handle no available channels
      print('No available channels');
    }
  }

  void dispose() {
    if (_channelName.isNotEmpty) {
      _firestore
          .collection('channels')
          .doc(_channelName)
          .update({'isOccupied': false});
    }
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
                enableHostControls:
                    true, // Add this to enable host controls if needed
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: AgoraVideoButtons(
                  client: _client!,
                  enabledButtons: const [
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
