import * as functions from "firebase-functions";
import {model} from "../../config/gemini";
import {
  PRICE_INPUT_PER_1M,
  PRICE_OUTPUT_PER_1M,
  PRICE_CACHING_PER_1M,
} from "../../constants/pricing";

interface GenerateQuestionRequest {
  categories: string[];
  language: string;
  count?: number;
}

export const generateQuestion = functions
  .runWith({
    secrets: ["GEMINI_API_KEY"],
    timeoutSeconds: 60,
  })
  .https.onCall(async (data: GenerateQuestionRequest, context) => {
    const {categories, language, count = 1} = data;

    if (!categories || !categories.length || !language) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with 'categories' (non-empty array) and 'language' arguments.",
      );
    }

    const categoriesStr = categories.join(", ");
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
        throw new functions.https.HttpsError(
          "internal",
          "Empty response from AI",
        );
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
          const outputCost =
            ((totalTokens - inputTokens - cachedTokens) / 1000000) *
            PRICE_OUTPUT_PER_1M;
          const totalCost = inputCost + outputCost + cachingCost;

          functions.logger.info("AI Cost Calculation", {
            inputTokens,
            outputTokens,
            cachedTokens,
            totalTokens,
            inputCost: inputCost.toFixed(10), // High precision for small costs
            outputCost: outputCost.toFixed(10),
            totalCost: totalCost.toFixed(10),
            currency: "USD",
          });
        }
      } catch (error) {
        console.error("Failed to generate or calculate cost:", error);
      }

      return JSON.parse(cleanText);
    } catch (e) {
      functions.logger.error("Error generating question:", e);
      functions.logger.log("Payload when error occurred:", data);
      throw new functions.https.HttpsError(
        "internal",
        "Failed to generate question",
        e,
      );
    }
  });
