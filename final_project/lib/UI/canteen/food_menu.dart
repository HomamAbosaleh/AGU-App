import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'meal.dart';
import 'payment.dart';
import '../schedule.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  _foodState createState() => _foodState();
}

class _foodState extends State<Food> {
  int currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final pages = [
    meal(),
    Schedule(),
    payments(),
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
          backgroundColor: Colors.red[400],
        ),
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          iconSize: 30,
          selectedFontSize: 15,
          selectedIconTheme: const IconThemeData(color: Colors.white, size: 40),
          selectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.red[400],
          unselectedIconTheme: const IconThemeData(
            color: Colors.black,
          ),
          unselectedItemColor: Colors.black,
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
        backgroundColor: Colors.grey[800],
    );
  }
}