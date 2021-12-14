import 'package:flutter/material.dart';

import 'meal.dart';
import 'payment.dart';
import 'schedule.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  int currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final pages = [
    const MealOfToday(),
    const Schedule(),
    const Payments(),
  ];
  final titles = [
    'December 10',
    'December',
    'My Wallet',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
        backgroundColor: const Color(0xF3000000),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
        iconSize: 30,
        selectedFontSize: 15,
        selectedIconTheme:
            const IconThemeData(color: Color(0xFFD00001), size: 40),
        selectedItemColor: const Color(0xFFD00001),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xF3000000),
        unselectedIconTheme: const IconThemeData(
          color: Color(0xFFD7D6D6),
        ),
        unselectedItemColor: const Color(0xFFD7D6D6),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Today\'s meal',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.date_range_rounded,
            ),
            label: 'Food Schedule',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet,
              ),
              label: 'Food Payments'),
        ],
      ),
      backgroundColor: const Color(0xFF181515),
    );
  }
}
