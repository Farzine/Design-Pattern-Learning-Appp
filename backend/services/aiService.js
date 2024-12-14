// services/aiService.js

const { GoogleGenerativeAI } = require("@google/generative-ai");
const mongoose = require('mongoose');
const PracticeSession = require('../models/PracticeSession');

// Load environment variables from .env file if available
require('dotenv').config();

// Initialize the Gemini AI client with your API key
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "YOUR_API_KEY"); // Replace with your actual API key or ensure it's set in environment variables

/**
 * Generates practice questions for a specified design pattern.
 *
 * @param {String} designPatternName - The name of the design pattern.
 * @param {mongoose.Types.ObjectId} userId - The ID of the user generating the questions.
 * @param {mongoose.Types.ObjectId} designPatternId - The ID of the design pattern.
 * @returns {Array<Object>} - An array containing practice question objects.
 * @throws {Error} - Throws an error if the Gemini API request fails.
 */
exports.generatePracticeQuestions = async (designPatternName, userId, designPatternId) => {
  const systemPrompt = "You are an expert in software design patterns and educational content creation.";

  const userPrompt = `Generate 5 multiple-choice practice questions for the following design pattern: "${designPatternName}". Each question should include the question text, four options labeled A, B, C, D, and indicate the correct answer. **Do not include any additional text, explanations, or Markdown formatting. Return only the questions in the following JSON format:**

[
  {
    "question": "Question text here",
    "options": {
      "A": "Option A",
      "B": "Option B",
      "C": "Option C",
      "D": "Option D"
    },
    "correctAnswer": "B"
  },
  ...
]`;

  try {
    // Retrieve the generative model
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    // Generate content using the model
    const result = await model.generateContent(`${systemPrompt}\n\n${userPrompt}`, {
      temperature: 0.7,
      maxOutputTokens: 1000,
    });

    // Log the raw AI response for debugging
    console.log('AI Response:', result.response.text());

    let aiText = result.response.text().trim();
    console.log('AI Text:', aiText);

    // Post-processing: Remove Markdown code block markers if present
    if (aiText.startsWith("```json") && aiText.endsWith("```")) {
      aiText = aiText.slice(7, -3).trim(); // Remove the first 7 characters (```json) and the last 3 characters (```)
    }

    // Ensure that the response starts with '[' and ends with ']'
    const jsonStart = aiText.indexOf('[');
    const jsonEnd = aiText.lastIndexOf(']');

    if (jsonStart === -1 || jsonEnd === -1) {
      throw new Error('AI response does not contain a valid JSON array.');
    }

    aiText = aiText.substring(jsonStart, jsonEnd + 1);

    // Parse the JSON response
    let questions;
    try {
      questions = JSON.parse(aiText);
    } catch (parseError) {
      console.error('Error parsing AI response JSON:', parseError.message);
      throw new Error('Failed to parse AI response.');
    }

    // Validate the structure of the questions
    if (!Array.isArray(questions)) {
      throw new Error('AI response is not an array of questions.');
    }

    questions.forEach(q => {
      if (
        !q.question ||
        !q.options ||
        typeof q.correctAnswer !== 'string' ||
        !['A', 'B', 'C', 'D'].includes(q.correctAnswer.toUpperCase())
      ) {
        throw new Error('AI response has an invalid question format.');
      }
    });

    // Create a new PracticeSession document
    const practiceSession = new PracticeSession({
      user_id: userId,
      design_pattern_id: designPatternId,
      questions,
    });

    await practiceSession.save();

    return questions;
  } catch (error) {
    console.error('Error generating practice questions:', error.message);
    throw new Error('Failed to generate practice questions.');
  }
};

/**
 * Evaluates a code submission for a specified design pattern.
 *
 * @param {String} designPatternName - The name of the design pattern.
 * @param {String} code - The code submission to be evaluated.
 * @returns {Object} - An object containing feedback and a correctness boolean.
 * @throws {Error} - Throws an error if the Gemini API request fails.
 */
exports.evaluateCodeSubmission = async (designPatternName, code) => {
  const systemPrompt = "You are an expert in software design patterns and code evaluation.";

  const userPrompt = `Evaluate the following code submission for the design pattern "${designPatternName}". Provide feedback on its correctness, adherence to the design pattern, and suggestions for improvement.

Code Submission:
${code}`;

  try {
    // Retrieve the generative model
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    // Generate content using the model
    const result = await model.generateContent(`${systemPrompt}\n\n${userPrompt}`, {
      temperature: 0.7,
      maxOutputTokens: 500,
    });

    // Log the raw AI response for debugging
    console.log('AI Evaluation Response:', result.response.text());

    let feedback = result.response.text().trim();

    // Post-processing: Remove Markdown code block markers if present
    if (feedback.startsWith("```json") && feedback.endsWith("```")) {
      feedback = feedback.slice(7, -3).trim(); // Remove the first 7 characters (```json) and the last 3 characters (```)
    }

    // Optionally, further clean the feedback if needed

    if (!feedback) throw new Error('No feedback received from Gemini API.');

    // Simple heuristic to determine correctness based on the presence of positive keywords
    const correctnessKeywords = ['correct', 'well done', 'good job', 'proper', 'appropriate', 'adheres'];
    const correct = correctnessKeywords.some((word) => feedback.toLowerCase().includes(word));

    return { feedback, correct };
  } catch (error) {
    console.error('Error evaluating code submission:', error.message);
    throw new Error('Failed to evaluate code submission.');
  }
};
