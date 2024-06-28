const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendVolunteerNotification = functions.firestore
  .document("channels/{channelId}")
  .onCreate(async (snap, context) => {
    const tokens = [];
    const volunteersSnapshot = await admin.firestore().collection("volunteers").get();
    volunteersSnapshot.forEach((doc) => {
      if (doc.data().fcmToken) {
        tokens.push(doc.data().fcmToken);
      }
    });

    const payload = {
      notification: {
        title: "Assistance Request",
        body: "A user is requesting assistance. Please respond.",
      },
      data: {
        channelId: context.params.channelId,
      },
    };

    await admin.messaging().sendToDevice(tokens, payload);
  });
