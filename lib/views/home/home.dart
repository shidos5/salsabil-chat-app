import 'package:flutter/material.dart';
import 'package:salsabil/views/chat_list.dart';

import 'package:salsabil/views/home/homepage.dart'; // Assuming this is the main content

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final List<Widget> _pages = [
    const Homepage(), // Replace with your actual homepage widget
    ChatList(),
    Container(
      child:
          Center(child: Text('Live Page')), // Replace with actual Live widget
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.live_tv_outlined), label: 'Live'),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: _pages,
      ),
    );
  }
}
