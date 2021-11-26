import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _scheduleState createState() => _scheduleState();
}

class _scheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Center(
    child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Monday,December 10'),
          Text('Main Dish: Lahmacun'),
          Text('Second Dish: Iskembe Corbasi'),
          Text('Salad: Salad'),
          Text('Fruit: Apple')
        ],
      ),
    );
  }
}
