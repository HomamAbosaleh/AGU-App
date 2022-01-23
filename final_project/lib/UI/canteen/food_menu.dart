import 'package:flutter/material.dart';
import 'week_menu.dart';
import 'payment.dart';
import 'meal_of_today.dart';
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
            Schedule(),
            MealOfToday(),
            Payments(),
          ],
        ),
      ),
    );
  }
}
