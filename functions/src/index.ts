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


