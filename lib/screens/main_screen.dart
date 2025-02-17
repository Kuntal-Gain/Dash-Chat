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

  List<Widget> _screens = [
    ChatScreen(),
    ImageGenerator(),
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
            Icon(
              Icons.flutter_dash,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            const Text(
              "Chat",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 20),
            Container(
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  type[currentIdx],
                  style: TextStyle(
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
            SizedBox(height: 40),
            ListTile(
              leading: Icon(
                Icons.chat,
                color: Colors.white,
              ),
              title: Text(
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
              leading: Icon(
                Icons.photo,
                color: Colors.white,
              ),
              title: Text(
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
