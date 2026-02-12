import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import {db} from "../../config/firebase";

interface DeleteUsersRequest {
  userIds: string[];
}

export const deleteUsers = functions.https.onCall(
  async (data: DeleteUsersRequest, context) => {
    const { userIds } = data;

    if (!Array.isArray(userIds)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with a 'userIds' array."
      );
    }

    const validUserIds = userIds.filter((id) => typeof id === 'string' && id.trim() !== "");

    if (validUserIds.length === 0) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with a 'userIds' array of strings containing at least one valid ID."
      );
    }

    try {
      const deleteResult = await admin.auth().deleteUsers(validUserIds);

      // Delete user documents from Firestore in batches of 500
      const batchSize = 500;
      for (let i = 0; i < validUserIds.length; i += batchSize) {
        const batch = db.batch();
        const chunk = validUserIds.slice(i, i + batchSize);
        chunk.forEach((id) => {
          const userRef = db.collection("users").doc(id);
          batch.delete(userRef);
        });
        await batch.commit();
      }

      if (deleteResult.failureCount > 0) {
          functions.logger.warn(`Failed to delete ${deleteResult.failureCount} users.`, deleteResult.errors);
      }

      return {
        successCount: deleteResult.successCount,
        failureCount: deleteResult.failureCount,
        errors: deleteResult.errors,
      };

    } catch (error) {
      functions.logger.error("Error deleting users:", error);
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while deleting users."
      );
    }
  }
);
