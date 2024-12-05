// services/aiService.js

const OpenAI = require('openai');
const PracticeSession = require('../models/PracticeSession');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY_NAFI,
});

/**
 * Generates practice questions for a specified design pattern.
 *
 * @param {String} designPatternName - The name of the design pattern.
 * @param {ObjectId} userId - The ID of the user generating the questions.
 * @param {ObjectId} designPatternId - The ID of the design pattern.
 * @returns {Array<Object>} - An array containing practice question objects.
 * @throws {Error} - Throws an error if the OpenAI API request fails.
 */
exports.generatePracticeQuestions = async (designPatternName, userId, designPatternId) => {
  const systemPrompt = 'You are an expert in software design patterns and educational content creation.';
  
  const userPrompt = `Generate 5 multiple-choice practice questions for the following design pattern: "${designPatternName}". Each question should include the question text, four options labeled A, B, C, D, and indicate the correct answer. Return the questions in the following JSON format:
  
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
    const response = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo', // or 'gpt-4' if available
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      max_tokens: 1000,
      temperature: 0.7,
    });

    const aiText = response.data.choices[0].message.content.trim();

    // Parse the JSON response
    const questions = JSON.parse(aiText);

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
    console.error('Error generating practice questions:', error.response ? error.response.data : error.message);
    throw new Error('Failed to generate practice questions.');
  }
};




/**
 * Evaluates a code submission for a specified design pattern.
 *
 * @param {String} designPatternId - The ID or name of the design pattern.
 * @param {String} code - The code submission to be evaluated.
 * @returns {Object} - An object containing feedback and a correctness boolean.
 * @throws {Error} - Throws an error if the OpenAI API request fails.
 */
exports.evaluateCodeSubmission = async (designPatternId, code) => {
  // Define the system prompt to set the context for the AI
  const systemPrompt = 'You are an expert in software design patterns and code evaluation.';

  // Define the user prompt with the specific request
  const userPrompt = `Evaluate the following code submission for the design pattern "${designPatternId}". Provide feedback on its correctness, adherence to the design pattern, and suggestions for improvement.\n\nCode Submission:\n${code}`;

  try {
    // Make a request to OpenAI's Chat Completion API
    const response = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo', // You can use 'gpt-4' if available
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      max_tokens: 500, // Adjust as needed
      temperature: 0.7, // Controls randomness; adjust between 0 and 1
    });

    // Extract the AI's response text
    const feedback = response.data.choices[0].message.content.trim();

    // Simple heuristic to determine correctness based on the presence of positive keywords
    const correctnessKeywords = ['correct', 'well done', 'good job', 'proper', 'appropriate', 'adheres'];
    const correct = correctnessKeywords.some((word) => feedback.toLowerCase().includes(word));

    return { feedback, correct };
  } catch (error) {
    console.error('Error evaluating code submission:', error.response ? error.response.data : error.message);
    throw new Error('Failed to evaluate code submission.');
  }
};
