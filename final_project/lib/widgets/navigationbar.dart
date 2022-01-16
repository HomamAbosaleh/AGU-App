import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/drawer.dart';
import '/UI/api/apipage.dart';
import '/UI/canteen/food_menu.dart';
import '/UI/chat/chatrooms.dart';
import '/UI/courses/courses.dart';
import '/UI/home.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int currentIndex = 2;
  void onItemTapped(int index) async {
    if (index == 3) {
      if (await Permission.location.isDenied) {
        await Permission.location.request();
      }
      if (await Permission.location.isGranted) {
        setState(() {
          currentIndex = index;
        });
      }

      return;
    }
    setState(() {
      currentIndex = index;
    });
  }

  final screens = const [
    Food(),
    CourseSchedule(),
    HomePage(),
    ApiPage(),
    Chat(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: customDrawer(context),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onItemTapped,
        currentIndex: currentIndex,
        iconSize: 30,
        selectedFontSize: 15,
        selectedIconTheme:
            const IconThemeData(color: Color(0xFFD00501), size: 40),
        selectedItemColor: const Color(0xFFD00001),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Color(0xff646464),
        ),
        unselectedItemColor: const Color(0xFFD7D6D6),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Food"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "API"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: "Chat")
        ],
      ),
    );
  }
}
