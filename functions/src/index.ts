/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";

import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

export const expireOldEvents = functions.pubsub
  .schedule("0 0 * * *")
  .timeZone("Europe/Tallinn")
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now();

    const snapshot = await db
      .collection("events")
      .where("end", "<=", now)
      .where("type", "not-in", ["canceled", "processed"])
      .get();

    if (snapshot.empty) {
      console.log("No outdated events to process.");
      return;
    }

    const batch = db.batch();

    snapshot.docs.forEach((doc) => {
      batch.update(doc.ref, {
        // TODO: add logic to set canceled. Set canceled externally?
        type: "processed",
      });
    });

    await batch.commit();
    console.log(`✅ Updated ${snapshot.size} events to status: processed`);
  });


export const checkEventsToNotify = functions.pubsub
  .schedule("every 1 minutes")
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now();
    const snapshot = await db.collection("events").get();

    const notifications: any[] = [];

    snapshot.forEach(async (doc) => {
      const data = doc.data();
      const startAt = new Date(data.start);
      const notifyBefore = data.notify_before || 0;
      const notifyAt = new Date(startAt.getTime() - notifyBefore * 1000);

      const diff = Math.abs(notifyAt.getTime() - now.toDate().getTime());

      if (diff < 60000) { // допуск ±1 минута
        const creatorsFcmToken = await getUserFCMToken(data.creator_id);
        if (creatorsFcmToken) {
          notifications
            .push(admin
              .messaging()
              .send(generateMessage(creatorsFcmToken, data)));
        }
        const friendsFcmToken = await getUserFCMToken(data.friend_id);
        if (friendsFcmToken) {
          notifications
            .push(admin
              .messaging()
              .send(generateMessage(friendsFcmToken, data)));
        }
      }
    });

    await Promise.all(notifications);
    console.log(`Notificarions sent: ${notifications.length}`);
  });


/**
 * Generates push notification.
 *
 * @param {string} fcmToken - token.
 * @param {Object} data - data.
 * @param {string} data.title - title.
 * @param {string} data.notify_before - time before.
 * @return {Object} object with data.
 * @property {string} token - token.
 * @property {Object} notification - notificatio.
 * @property {string} notification.title - title.
 * @property {string} notification.body - text.
 */
function generateMessage(fcmToken: string, data: any) {
  return {
    token: fcmToken,
    notification: {
      title: `${data.title}`,
      body: `The ${data.title} will start in: ${data.notify_before}`,
    },
  };
}


/**
 * Gets users token from Firestore.
 *
 * @param {string} userId - users id.
 * @return {Promise<string | null>} promise with id or null.
 */
async function getUserFCMToken(userId: string) {
  const userRef = admin.firestore().collection("users").doc(userId);
  const userDoc = await userRef.get();
  if (userDoc.exists) {
    return userDoc.data()?.fmc_token;
  }
  return null;
}

