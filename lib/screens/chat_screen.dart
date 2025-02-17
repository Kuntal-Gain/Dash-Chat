import 'package:chat_ai/services/web_socket_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketServices _webSocketService =
      WebSocketServices('ws://10.0.2.2:8000');
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
// Buffer to accumulate AI responses

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _webSocketService.messages.listen((data) {
      setState(() {
        // Remove "AI is Thinking..." message if it exists
        if (messages.isNotEmpty &&
            !messages.last.isUser &&
            messages.last.text == "AI is Thinking...") {
          messages.removeLast();
        }

        if (!messages.isNotEmpty || messages.last.isUser) {
          // Start a new AI message
          messages.add(Message(data.trim(), false));
        } else {
          // Append to existing AI message
          messages.last.text += " ${data.trim()}";
          messages.last.text = messages.last.text.trim();
        }
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282424),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white), // White text color
              decoration: InputDecoration(
                hintText: "Ask AI...",
                hintStyle: const TextStyle(
                    color: Colors.white70), // Slightly dimmed hint
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send,
                color: Colors.white), // Send button in white
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  messages
                      .add(Message(controller.text, true)); // User's message
                  messages
                      .add(Message("AI is Thinking...", false)); // Placeholder
                });

                _webSocketService.sendMessage(controller.text);
                controller.clear();
                _scrollToBottom();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Row(
      mainAxisAlignment:
          message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // AI Icon (Left side)
        if (!message.isUser)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.flutter_dash_outlined,
                color: Colors.grey[400], size: 30),
          ),

        Flexible(
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser
                  ? const Color(0xff383434)
                  : const Color(0xff282424),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft:
                    message.isUser ? const Radius.circular(12) : Radius.zero,
                bottomRight:
                    message.isUser ? Radius.zero : const Radius.circular(12),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              child: MarkdownBody(
                data: message.text, // Render Markdown!
                selectable: true, // Allows users to copy text
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 16, color: Colors.white),
                  strong: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  em: const TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white70),
                  code: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    backgroundColor: Color(0xFF1E1E1E),
                    color: Color(0xFFCCCCCC),
                    // padding: EdgeInsets.all(6),
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3C3C3C)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _webSocketService.disconnect();
    super.dispose();
  }
}

// Message class to store chat messages
class Message {
  String text;
  final bool isUser;
  Message(this.text, this.isUser);
}
