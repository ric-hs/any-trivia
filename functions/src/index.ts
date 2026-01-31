import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { GoogleGenerativeAI } from "@google/generative-ai";

admin.initializeApp();
const db = admin.firestore();

const PRICE_INPUT_PER_1M = 0.50;
const PRICE_OUTPUT_PER_1M = 3.00;
const PRICE_CACHING_PER_1M = 0.05;

// Initialize Gemini with API key from environment variables
// Ensure to set the secret using: firebase functions:secrets:set GEMINI_API_KEY
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");
const model = genAI.getGenerativeModel({ model: "gemini-3-flash-preview" });

interface GenerateQuestionRequest {
  categories: string[];
  language: string;
  count?: number;
}

export const generateQuestion = functions.runWith({
  secrets: ["GEMINI_API_KEY"],
  timeoutSeconds: 60,
}).https.onCall(async (data: GenerateQuestionRequest, context) => {
  const { categories, language, count = 1 } = data;

  if (!categories || !categories.length || !language) {
    throw new functions.https.HttpsError("invalid-argument", "The function must be called with 'categories' (non-empty array) and 'language' arguments.");
  }

  const categoriesStr = categories.join(', ');
  let prompt: string;

  if (count > 1) {
     prompt = `
      Generate ${count} trivia questions. For each question, randomly select one category from this list: [${categoriesStr}].
      The questions should be in "${language}".
      Return a JSON array of objects, where each object has the following schema:
      {
        "question": "The question text",
        "answers": ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
        "correctIndex": 0, // Index of the correct answer (0-3)
        "category": "The selected category"
      }
      Ensure there is exactly one correct answer and 3 incorrect ones for each question.
      Make the questions challenging but fun.
      RETURN ONLY THE RAW JSON. NO MARKDOWN.
    `;
  } else {
    prompt = `
      Generate a trivia question. Randomly select one category from this list: [${categoriesStr}].
      The question should be in "${language}".
      Return a JSON object inside an array with the following schema:
      {
        "question": "The question text",
        "answers": ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
        "correctIndex": 0, // Index of the correct answer (0-3)
        "category": "The selected category"
      }
      Ensure there is exactly one correct answer and 3 incorrect ones.
      Make the question challenging but fun.
      RETURN ONLY THE RAW JSON. NO MARKDOWN.
    `;
  }

  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    if (!text) {
        throw new functions.https.HttpsError("internal", "Empty response from AI");
    }

    // Clean up potential markdown code blocks if the model includes them
    const cleanText = text.replace(/```json\n?|\n?```/g, "").trim();

    try {
      const usage = result.response.usageMetadata;
    if (usage) {
        const inputTokens = usage.promptTokenCount || 0;
        const outputTokens = usage.candidatesTokenCount || 0;
        const cachedTokens = usage.cachedContentTokenCount || 0;
        const totalTokens = usage.totalTokenCount || 0;
        
        const inputCost = (inputTokens / 1000000) * PRICE_INPUT_PER_1M;
        const cachingCost = (cachedTokens / 1000000) * PRICE_CACHING_PER_1M;
        const outputCost = ((totalTokens - inputTokens - cachedTokens) / 1000000) * PRICE_OUTPUT_PER_1M;
        const totalCost = inputCost + outputCost + cachingCost;

        functions.logger.info("AI Cost Calculation", {
          inputTokens,
          outputTokens,
          cachedTokens,
          totalTokens,
          inputCost: inputCost.toFixed(10), // High precision for small costs
          outputCost: outputCost.toFixed(10),
          totalCost: totalCost.toFixed(10),
          currency: "USD"
        });
      }

    } catch (error) {
      console.error("Failed to generate or calculate cost:", error);
    }


    return JSON.parse(cleanText);
  } catch (e) {
    functions.logger.error("Error generating question:", e);
    functions.logger.log("Payload when error occurred:", data);
    throw new functions.https.HttpsError("internal", "Failed to generate question", e);
  }
});

interface ConsumeTokensRequest {
  numberOfTokens: number;
  userId: string;
}

export const consumeTokens = functions.https.onCall(async (data: ConsumeTokensRequest, context) => {
  const { numberOfTokens, userId } = data;

  if (typeof numberOfTokens !== "number" || numberOfTokens <= 0 || !userId) {
    throw new functions.https.HttpsError("invalid-argument", "The function must be called with 'numberOfTokens' (positive number) and 'userId' arguments.");
  }

  const userRef = db.collection("users").doc(userId);

  try {
    const result = await db.runTransaction(async (transaction) => {
      const userDoc = await transaction.get(userRef);

      if (!userDoc.exists) {
        throw new functions.https.HttpsError("not-found", "User profile not found.");
      }

      const currentTokens = userDoc.data()?.tokens || 0;

      if (currentTokens < numberOfTokens) {
        return { status: "insufficient_balance", message: "Current balance is lower than the required tokens." };
      }

      transaction.update(userRef, {
        tokens: currentTokens - numberOfTokens,
      });

      return { status: "ok", message: "Tokens consumed successfully." };
    });

    return result;
  } catch (error) {
    functions.logger.error("Error consuming tokens:", error);
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    throw new functions.https.HttpsError("internal", "An error occurred while consuming tokens.");
  }
});


interface GrantInitialTokensRequest {
  deviceId: string;
}

export const grantInitialTokens = functions.https.onCall(async (data: GrantInitialTokensRequest, context) => {
  const { deviceId } = data;

  if (!deviceId) {
    throw new functions.https.HttpsError("invalid-argument", "The function must be called with a 'deviceId'.");
  }

  // Ensure the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
  }

  const userId = context.auth.uid;
  const deviceRef = db.collection("claimed_initial_tokens").doc(deviceId);
  const userRef = db.collection("users").doc(userId);

  try {
    const result = await db.runTransaction(async (transaction) => {
      const deviceDoc = await transaction.get(deviceRef);

      if (deviceDoc.exists) {
        throw new functions.https.HttpsError("already-exists", "Initial tokens have already been claimed for this device.");
      }

      const userDoc = await transaction.get(userRef);

      // We allow granting initial tokens only if the user doesn't already have a token field
      // or if they have 0 tokens and haven't claimed before.
      // However, the primary check is the Device ID.
      if (userDoc.exists && userDoc.data()?.hasClaimedInitialTokens) {
        throw new functions.https.HttpsError("already-exists", "Initial tokens have already been claimed for this user.");
      }

      // Mark device as used
      transaction.set(deviceRef, {
        userId: userId,
        claimedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Update user profile with initial tokens
      transaction.set(userRef, {
        tokens: 10,
        hasClaimedInitialTokens: true,
      }, { merge: true });

      return { status: "ok", message: "Initial tokens granted successfully." };
    });

    return result;
  } catch (error) {
    functions.logger.error("Error granting initial tokens:", error);
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    throw new functions.https.HttpsError("internal", "An error occurred while granting initial tokens.");
  }
});
