import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '/UI/api/currency.dart';
import '/UI/api/location.dart';
import '/UI/api/weather.dart';
import '../../widgets/drawer.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  int currentInd = 1;
  final List<Widget> _apipagenames = <Widget>[
    const Text('University Location'),
    const Text('Currency Exchange'),
    const Text('Kayseri Weather'),
  ];

  void getPermissions() async {
    await Permission.location.request();
  }

  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: customDrawer(context),
        appBar: AppBar(
          title: _apipagenames.elementAt(currentInd),
          centerTitle: true,
          bottom: TabBar(
              labelColor: Theme.of(context).hoverColor,
              indicatorColor: Theme.of(context).hoverColor,
              unselectedLabelColor: Theme.of(context).disabledColor,
              tabs: const [
                Tab(icon: Icon(Icons.location_on_rounded)),
                Tab(icon: Icon(Icons.attach_money)),
                Tab(icon: Icon(Icons.cloud)),
              ]),
        ),
        body: const TabBarView(children: [
          Location(),
          Currency(),
          Weather(),
        ]),
      ),
    );
  }
}
