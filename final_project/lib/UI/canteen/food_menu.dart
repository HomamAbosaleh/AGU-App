import 'package:flutter/material.dart';
import 'meal.dart';
import 'payment.dart';
import 'schedule.dart';
import '../../widgets/drawer.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  int currentIndex = 0;
  void onItemTapped(int index) {
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
    'Today\'s meal',
    'Scedule',
    'My Wallet',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: customDrawer(context),
        appBar: AppBar(
          centerTitle: true,
          title:
              Text("Dining Hall", style: Theme.of(context).textTheme.headline3),
          bottom: TabBar(
              labelColor: Theme.of(context).hoverColor,
              indicatorColor: Theme.of(context).hoverColor,
              unselectedLabelColor: Theme.of(context).disabledColor,
              tabs: const [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.date_range_rounded)),
                Tab(icon: Icon(Icons.account_balance_wallet))
              ]),
        ),
        body: const TabBarView(
          children: [
            MealOfToday(),
            Schedule(),
            Payments(),
          ],
        ),
        // body: pages[currentIndex],
        // bottomNavigationBar: SingleChildScrollView(
        //   child: BottomNavigationBar(
        //     currentIndex: currentIndex,
        //     onTap: _onItemTapped,
        //     iconSize: 30,
        //     selectedFontSize: 15,
        //     selectedIconTheme:
        //         const IconThemeData(color: Color(0xFFD00001), size: 40),
        //     selectedItemColor: const Color(0xFFD00001),
        //     selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        //     unselectedIconTheme: const IconThemeData(
        //       color: Color(0xFFD7D6D6),
        //     ),
        //     unselectedItemColor: const Color(0xFFD7D6D6),
        //     items: const <BottomNavigationBarItem>[
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.access_time),
        //         label: 'Today\'s meal',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.date_range_rounded,
        //         ),
        //         label: 'Food Schedule',
        //       ),
        //       BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.account_balance_wallet,
        //           ),
        //           label: 'Food Payments'),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
