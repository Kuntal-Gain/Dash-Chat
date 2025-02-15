# Dash-Chat 💬
An AI Chat Application can interact with users requests it generate text from user prompts it can write paragraphs,posts,code snippets,build using websockets and Gemini API.

## Features ✨
- Generate Text
- Generate Code Snippets
- Disposable Message (currently , soon we will build memory)

## Tech Stack 🛠️
- Flutter
- Dart
- Web Sockets
- Gemini AI

## Prerequisites 📋
client-side
```
flutter pub get
```
server-side
```
cd server
node -v
npm -v
```
## Installation🚀
```
git clone https://github.com/Kuntal-Gain/Dash-Chat.git
cd dash-chat
cd server
npm i && npm install
```

## Usage💡
```
node server/server.js
flutter run
```

## Environment Variables 🔒
```
GEMINI_API_KEY=your_api_key
```
## Project Structure 📂
```
lib/
├──service
    ├─web_socket_service.dart
├── pages
    ├─chat_screen.dart
└── main.dart
```

## Contributing 🤝
- Fork the project
- Create your feature branch
- Commit your changes
- Push to the branch
- Open a pull request