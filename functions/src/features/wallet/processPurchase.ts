import * as functions from "firebase-functions";
import { FieldValue } from "firebase-admin/firestore";
import { defineSecret } from "firebase-functions/params";
import {db} from "../../config/firebase";

const revenueCatAuthHeader = defineSecret("REVENUECAT_AUTH_HEADER");

// Define the structure of the RevenueCat webhook event
// We only need a few fields for this implementation
interface RevenueCatEvent {
  id: string;
  type: string;
  app_user_id: string;
  product_id: string;
  purchased_at_ms: number;
}

interface RevenueCatWebhookBody {
  event: RevenueCatEvent;
  api_version: string;
}

// Map product IDs to token amounts
const PRODUCT_TOKENS: Record<string, number> = {
  "anytrivia_anytokens_20_v1": 20,
  "anytrivia_anytokens_50_v1": 50,
  "anytrivia_anytokens_100_v1": 100,
  "anytrivia_anytokens_200_v1": 200,
};

export const processPurchase = functions.runWith({ secrets: [revenueCatAuthHeader] }).https.onRequest(async (req, res) => {
  // 1. Verify Authorization Header
  // Using Google Cloud Secret REVENUECAT_AUTH_HEADER
  const authHeader = req.headers.authorization;
  const expectedAuthHeader = revenueCatAuthHeader.value();

  if (!expectedAuthHeader || authHeader !== expectedAuthHeader) {
    functions.logger.warn("Unauthorized webhook attempt", {authHeader});
    res.status(401).send("Unauthorized");
    return;
  }

  try {
    const body = req.body as RevenueCatWebhookBody;
    const {event} = body;

    if (!event) {
      functions.logger.error("Missing event in body", {body});
      res.status(400).send("Bad Request: Missing event");
      return;
    }

    const {id, type, app_user_id, product_id} = event;

    // We only care about initial purchases or renewals that give tokens
    // For consumable tokens, it's usually INITIAL_PURCHASE or NON_RENEWING_PURCHASE depending on setup
    // Checking for 'NON_RENEWING_PURCHASE' or 'INITIAL_PURCHASE' might be needed
    // But for now, let's filter by product ID presence in our map.
    // If it's a known product, we process it.
    
    // NOTE: RevenueCat sends many event types (TEST, RENEWAL, etc).
    // You might want to filter strictly by `type`.
    // Common types for consumables: 'INITIAL_PURCHASE', 'NON_RENEWING_PURCHASE'.
    // Let's assume we process if the product ID matches our token packages.

    const tokensToAdd = PRODUCT_TOKENS[product_id];

    if (!tokensToAdd) {
      functions.logger.error(`Product ${product_id} is not a token package. Skipping.`);
      // Return 200 so RevenueCat doesn't retry
      res.status(200).send("Skipped: Not a token package");
      return;
    }

    // 2. Idempotency Check
    const eventRef = db.collection("processed_events").doc(id);
    
    // We use a transaction to ensure atomicity of the check and the user update
    await db.runTransaction(async (transaction) => {
      const eventDoc = await transaction.get(eventRef);
      if (eventDoc.exists) {
        functions.logger.info(`Event ${id} already processed.`);
        return;
      }

      const userRef = db.collection("users").doc(app_user_id);
      const userDoc = await transaction.get(userRef);

      if (!userDoc.exists) {
        functions.logger.info(`User ${app_user_id} not found. Creating new user with ${tokensToAdd} tokens.`);
        transaction.set(userRef, {
          tokens: tokensToAdd,
          createdAt: FieldValue.serverTimestamp(),
        }, {merge: true});
      } else {
        functions.logger.info(`User ${app_user_id} found. Adding ${tokensToAdd} tokens.`);
        const currentTokens = userDoc.data()?.tokens || 0;
        transaction.update(userRef, {
          tokens: currentTokens + tokensToAdd,
        });
        functions.logger.info(`Added ${tokensToAdd} tokens to user ${app_user_id}`);
      }

      // Mark event as processed
      transaction.set(eventRef, {
        processedAt: FieldValue.serverTimestamp(),
        event_type: type,
        product_id: product_id,
        user_id: app_user_id,
      });
    });

    res.status(200).send("OK");
  } catch (error) {
    functions.logger.error("Error processing purchase webhook", error);
    // If it's a transient error, we might want RevenueCat to retry (return 500).
    // If it's a permanent logic error, return 200 to stop retries.
    res.status(500).send("Internal Server Error");
  }
});
