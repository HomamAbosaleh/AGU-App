import 'meal.dart';
import 'payments.dart';
import 'scedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const food());

class food extends StatefulWidget {
  const food({Key? key}) : super(key: key);

  @override
  _foodState createState() => _foodState();
}

class _foodState extends State<food> {
  int currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final pages = [
    meal(),
    schedule(),
    payments(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            DateFormat.MMMMEEEEd().format(DateTime.now()),
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
          backgroundColor: Colors.red[400],
        ),
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          iconSize: 30,
          selectedFontSize: 20,
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
      ),
    );
  }
}
