import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'currency.dart';
import 'location.dart';
import 'weather.dart';
import '../../widgets/drawer.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  _ApiPageState createState() => _ApiPageState();
}
class _ApiPageState extends State<ApiPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late String currentTitle;
  final List<String> pageNames = <String>[
    'University Location',
    'Currency Exchange',
    'Weather',
  ];

  void changeTitle() {
    setState(() {
      currentTitle = pageNames[tabController.index];
    });
  }

  @override
  void initState() {
    currentTitle = pageNames[0];
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
          title: Text(currentTitle),
          centerTitle: true,
          bottom: TabBar(
              controller: tabController,
              labelColor: Theme.of(context).hoverColor,
              indicatorColor: Theme.of(context).hoverColor,
              unselectedLabelColor: Theme.of(context).disabledColor,
              tabs: const [
                Tab(icon: Icon(Icons.location_on_rounded)),
                Tab(icon: Icon(Icons.attach_money)),
                Tab(icon: Icon(Icons.cloud)),
              ]),
        ),
        body: TabBarView(controller: tabController, children: [
          const Location(),
          const Currency(),
          Weather(),
        ]),
      ),
    );
  }
}
