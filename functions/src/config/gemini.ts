import {GoogleGenerativeAI} from "@google/generative-ai";

// Initialize Gemini with API key from environment variables
// Ensure to set the secret using: firebase functions:secrets:set GEMINI_API_KEY
export const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");
export const model = genAI.getGenerativeModel({
  model: "gemini-3-flash-preview",
  generationConfig: {
    responseMimeType: "application/json",
  },
});
