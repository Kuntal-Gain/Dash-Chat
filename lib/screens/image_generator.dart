import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ImageGenerator extends StatefulWidget {
  const ImageGenerator({super.key});

  @override
  State<ImageGenerator> createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];

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

  Future<void> _handleUserMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    setState(() {
      messages.add(Message(prompt, true)); // User message
      messages.add(Message("AI is Thinking...", false)); // Placeholder
    });

    _scrollToBottom();

    // Step 1: Get event_id
    String? eventId = await _apiService.getEventId(prompt);
    if (eventId == null) {
      setState(() {
        messages.last.text = "Error: Failed to generate image.";
      });
      return;
    }

    // Step 2: Wait for AI to process the image (1-2 seconds recommended)
    await Future.delayed(const Duration(seconds: 2)); // Adjust as needed

    // Step 3: Fetch image URL
    String? imageUrl = await _apiService.generateImage(eventId);
    if (imageUrl == null) {
      setState(() {
        messages.last.text = "Error: Could not retrieve image.";
      });
    } else {
      setState(() {
        messages.last = Message(imageUrl, false, isImage: true);
      });
    }

    _scrollToBottom();
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ask AI...",
                hintStyle: const TextStyle(color: Colors.white70),
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
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _handleUserMessage(controller.text);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
              message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // Icon for AI message (Left side)
            if (!message.isUser)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.flutter_dash_outlined,
                  color: Colors.grey[400],
                  size: 30,
                ),
              ),
            // Message container
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: message.isImage
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xff383434),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            message.text,
                            width: 250,
                            height: 250,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xff383434),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!message.isUser)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ),
                            Flexible(
                              child: Text(
                                message.text,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void initState() {
  //   // Will print the cleaned image URL
  //   testMethod();
  //   super.initState();
  // }

  // void testMethod() async {
  //   String? eventId = await ApiService().getEventId("Sunset");
  //   String? imageUrl = await ApiService().generateImage(eventId!);
  //   print(imageUrl);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282424),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[index]);
              },
            ),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }
}

class Message {
  String text;
  final bool isUser;
  final bool isImage;

  Message(this.text, this.isUser, {this.isImage = false});
}
