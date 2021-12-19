import 'package:final_project/UI/api/apipage.dart';
import 'package:final_project/UI/canteen/food_menu.dart';
import 'package:final_project/UI/chat/chatrooms.dart';
import 'package:final_project/UI/courses/courses.dart';
import 'package:final_project/UI/home.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

import 'package:flutter/cupertino.dart';

import '../widgets/appbar.dart';

class CustomNavigationbar extends StatefulWidget {
  const CustomNavigationbar({Key? key}) : super(key: key);

  @override
  _CustomNavigationbarState createState() => _CustomNavigationbarState();
}

class _CustomNavigationbarState extends State<CustomNavigationbar> {
  @override
  int currentIndex = 2;
  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final screens = const [
    Food(),
    CourseSchedule(),
    HomePage(),
    apiPage(),
    Chat(),
  ];
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
            const IconThemeData(color: Color(0xFFD00001), size: 40),
        selectedItemColor: const Color(0xFFD00001),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Color(0xFFD7D6D6),
        ),
        unselectedItemColor: const Color(0xFFD7D6D6),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Food"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "Wifi"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: "Chat")
        ],
      ),
    );
  }
}
