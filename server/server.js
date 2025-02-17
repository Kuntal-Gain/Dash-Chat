require("dotenv").config();
const WebSocket = require("ws");
const axios = require("axios");

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

const wss = new WebSocket.Server({ port: 8000 });

console.log("WebSocket server running on ws://localhost:8000");

wss.on("connection", (ws) => {
    console.log("Client connected");

    ws.on("message", async (message) => {
        console.log(`Received: ${message}`);

        try {
            const response = await getAIResponse(message.toString());
            for (const word of response.split(" ")) {
                ws.send(word); // Stream response word by word
                await new Promise((resolve) => setTimeout(resolve, 100));
            }
        } catch (error) {
            console.error("Error fetching AI response:", error.response?.data || error.message);
            ws.send("Error fetching AI response");
        }
    });

    ws.on("close", () => {
        console.log("Client disconnected");
    });
});

async function getAIResponse(userMessage) {
    const requestBody = {
        contents: [
            {
                parts: [{ text: userMessage }],
            },
        ],
    };

    const response = await axios.post(GEMINI_API_URL, requestBody, {
        headers: { "Content-Type": "application/json" },
    });

    return response.data.candidates?.[0]?.content?.parts?.[0]?.text || "I couldn't process that.";
}