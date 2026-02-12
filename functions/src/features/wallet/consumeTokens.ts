import * as functions from "firebase-functions";
import {db} from "../../config/firebase";

interface ConsumeTokensRequest {
  numberOfTokens: number;
  userId: string;
}

export const consumeTokens = functions.https.onCall(
  async (data: ConsumeTokensRequest, context) => {
    const {numberOfTokens, userId} = data;

    if (typeof numberOfTokens !== "number" || numberOfTokens <= 0 || !userId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with 'numberOfTokens' (positive number) and 'userId' arguments.",
      );
    }

    const userRef = db.collection("users").doc(userId);

    try {
      const result = await db.runTransaction(async (transaction) => {
        const userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw new functions.https.HttpsError(
            "not-found",
            "User profile not found.",
          );
        }

        const currentTokens = userDoc.data()?.tokens || 0;

        if (currentTokens < numberOfTokens) {
          return {
            status: "insufficient_balance",
            message: "Current balance is lower than the required tokens.",
          };
        }

        transaction.update(userRef, {
          tokens: currentTokens - numberOfTokens,
        });

        return {status: "ok", message: "Tokens consumed successfully."};
      });

      return result;
    } catch (error) {
      functions.logger.error("Error consuming tokens:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while consuming tokens.",
      );
    }
  },
);
