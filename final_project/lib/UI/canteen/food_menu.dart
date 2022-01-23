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

class _FoodState extends State<Food> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentIndex = 0;
  late String currentTitle;
  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void changeTitle() {
    setState(() {
      currentTitle = titles[tabController.index];
    });
  }

  final pages = [
    const MealOfToday(),
    const Schedule(),
    const Payments(),
  ];
  final titles = [
    'Today\'s Meal',
    'Week\'s Menu',
    'My Wallet',
  ];
  @override
  void initState() {
    currentTitle = titles[0];
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(changeTitle);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: customDrawer(context),
        appBar: AppBar(
          centerTitle: true,
          title:
              Text(currentTitle, style: Theme.of(context).textTheme.headline3),
          bottom: TabBar(
              controller: tabController,
              labelColor: Theme.of(context).hoverColor,
              indicatorColor: Theme.of(context).hoverColor,
              unselectedLabelColor: Theme.of(context).disabledColor,
              tabs: const [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.date_range_rounded)),
                Tab(icon: Icon(Icons.account_balance_wallet))
              ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            Schedule(),
            MealOfToday(),
            Payments(),
          ],
        ),
      ),
    );
  }
}
