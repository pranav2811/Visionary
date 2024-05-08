// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> getOrCreateChannel(bool isUser) async {
    String userType = isUser ? 'userCount' : 'volunteerCount';
    String oppositeType = isUser ? 'volunteerCount' : 'userCount';

    try {
      var querySnapshot = await _db
          .collection('channels')
          .where(userType, isEqualTo: 0)
          .where(oppositeType, isGreaterThan: 0)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference channelRef = querySnapshot.docs.first.reference;
        await channelRef.update({userType: FieldValue.increment(1)});
        return channelRef.id;
      } else {
        var newChannel = await _db.collection('channels').add({
          'userCount': isUser ? 1 : 0,
          'volunteerCount': isUser ? 0 : 1,
        });
        return newChannel.id;
      }
    } catch (e) {
      print('Error occurred while accessing Firestore: $e');
      rethrow;
    }
  }

  Future<void> leaveChannel(String channelId, bool isUser) async {
    String userType = isUser ? 'userCount' : 'volunteerCount';

    try {
      DocumentReference docRef = _db.collection('channels').doc(channelId);
      // Decrement the appropriate user count
      await docRef.update({userType: FieldValue.increment(-1)});
      // Retrieve the updated document to check counts
      var channelDoc = await docRef.get();
      var data = channelDoc.data() as Map<String, dynamic>;
      if (data['userCount'] == 0 && data['volunteerCount'] == 0) {
        // If both counts are zero, delete the channel
        await docRef.delete();
      }
    } catch (e) {
      print('Error occurred while updating Firestore: $e');
      rethrow;
    }
  }
} 
