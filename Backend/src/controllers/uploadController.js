const dotenv = require('dotenv');
dotenv.config();
const fs = require('fs');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const genAI = new GoogleGenerativeAI(process.env.VITE_API_KEY);
const uploadImage = async (req, res) => {
  try {
    const imagePath = req.file.path;
    const userQuestion = req.body.question;

    const imageBuffer = fs.readFileSync(imagePath);
    const imageBase64 = imageBuffer.toString('base64');

    const prePrompt = `
      You are a Blood Donation Assistant and Blood Report Explainer. 
      Your job is to:
      - Guide users about **blood donation** eligibility and process.
      - Explain **blood test results** in simple terms.
      - Identify potential **health concerns** based on blood reports.
      - Provide **to-the-point** responses (under 3 sentences).
      - **Avoid unnecessary disclaimers** like "consult a doctor" unless absolutely necessary.
      - No long paragraphs, keep it short and **informative**.
    `;

    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

    const response = await model.generateContent([
      { text: prePrompt },
      { text: userQuestion },
      { inlineData: { mimeType: 'image/png', data: imageBase64 } } 
    ]);

    const result = await response.response;
    const text = result.text();
    res.json({ answer: text });

    fs.unlinkSync(imagePath);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error processing request' });
  }
};

module.exports = { uploadImage };