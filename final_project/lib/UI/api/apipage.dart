import 'package:flutter/material.dart';

import 'currency.dart';
import 'location.dart';
import 'weather.dart';
import '../../widgets/drawer.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  int currentInd = 0;
  final List<Widget> _apipagenames = <Widget>[
    const Text('University Location'),
    const Text('Currency Exchange'),
    const Text('Kayseri Weather'),
  ];

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
        body: TabBarView(children: [
          const Location(),
          const Currency(),
          Weather(),
        ]),
      ),
    );
  }
}
