import 'package:chat_ai/screens/chat_screen.dart';
import 'package:chat_ai/screens/image_generator.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIdx = 0;

  final List<Widget> _screens = [
    const ChatScreen(),
    const ImageGenerator(),
  ];

  List<String> type = ["Text", "Image"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff282424),
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Row(
          children: [
            const Icon(
              Icons.flutter_dash,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text(
              "Chat",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  type[currentIdx],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xff282424),
        child: Column(
          children: [
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(
                Icons.chat,
                color: Colors.white,
              ),
              title: const Text(
                "Text Generation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() => currentIdx = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo,
                color: Colors.white,
              ),
              title: const Text(
                "Image Generation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() => currentIdx = 1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[currentIdx],
    );
  }
}
