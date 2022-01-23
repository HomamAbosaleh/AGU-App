import 'package:flutter/cupertino.dart';
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

class _ApiPageState extends State<ApiPage> with SingleTickerProviderStateMixin{
   late TabController _tcontroller;
   late String currentTitle;
  final List<String> _apipagenames = <String>[
     'University Location',
     'Currency Exchange',
     'Weather',
  ];

  void getPermissions() async {
    await Permission.location.request();
  }

  @override
  void initState() {
    currentTitle = _apipagenames[0];
    _tcontroller = TabController(length: 3, vsync: this);
    _tcontroller.addListener(changeTitle); // Registering listener
    super.initState();
  }

  // This function is called, every time active tab is changed
  void changeTitle() {
    setState(() {
      // get index of active tab & change current appbar title
      currentTitle = _apipagenames[_tcontroller.index];
    });
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
              controller: _tcontroller,
              labelColor: Theme.of(context).hoverColor,
              indicatorColor: Theme.of(context).hoverColor,
              unselectedLabelColor: Theme.of(context).disabledColor,
              tabs: const [
                Tab(icon: Icon(Icons.location_on_rounded)),
                Tab(icon: Icon(Icons.attach_money)),
                Tab(icon: Icon(Icons.cloud)),
              ]),
        ),
        body: TabBarView(
            controller: _tcontroller,
            children: [
          const Location(),
          const Currency(),
          Weather(),
        ]),
      ),
    );
  }
}
