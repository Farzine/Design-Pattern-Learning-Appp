// config/openai.js
const config = require('config');
const { Configuration, OpenAIApi } = require('openai');

const configuration = new Configuration({
  apiKey: config.get('openAIKey'),
});

const openai = new OpenAIApi(configuration);

module.exports = openai;

