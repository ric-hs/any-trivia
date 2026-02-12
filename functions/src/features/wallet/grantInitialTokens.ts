import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {db} from "../../config/firebase";

interface GrantInitialTokensRequest {
  deviceId: string;
}

export const grantInitialTokens = functions.https.onCall(
  async (data: GrantInitialTokensRequest, context) => {
    const {deviceId} = data;

    if (!deviceId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with a 'deviceId'.",
      );
    }

    // Ensure the user is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const userId = context.auth.uid;
    const deviceRef = db.collection("claimed_initial_tokens").doc(deviceId);
    const userRef = db.collection("users").doc(userId);

    try {
      const result = await db.runTransaction(async (transaction) => {
        const deviceDoc = await transaction.get(deviceRef);

        if (deviceDoc.exists) {
          throw new functions.https.HttpsError(
            "already-exists",
            "Initial tokens have already been claimed for this device.",
          );
        }

        const userDoc = await transaction.get(userRef);

        // We allow granting initial tokens only if the user doesn't already have a token field
        // or if they have 0 tokens and haven't claimed before.
        // However, the primary check is the Device ID.
        if (userDoc.exists && userDoc.data()?.hasClaimedInitialTokens) {
          throw new functions.https.HttpsError(
            "already-exists",
            "Initial tokens have already been claimed for this user.",
          );
        }

        // Mark device as used
        transaction.set(deviceRef, {
          userId: userId,
          claimedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Update user profile with initial tokens
        transaction.set(
          userRef,
          {
            tokens: 10,
            hasClaimedInitialTokens: true,
          },
          {merge: true},
        );

        return {status: "ok", message: "Initial tokens granted successfully."};
      });

      return result;
    } catch (error) {
      functions.logger.error("Error granting initial tokens:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while granting initial tokens.",
      );
    }
  },
);
