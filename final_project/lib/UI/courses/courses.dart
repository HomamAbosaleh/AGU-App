import 'package:final_project/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '/../widgets/appbar.dart';

class CourseSchedule extends StatefulWidget {
  const CourseSchedule({Key? key}) : super(key: key);

  @override
  _CourseScheduleState createState() => _CourseScheduleState();
}

class _CourseScheduleState extends State<CourseSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: customDrawer(context),
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
      ),
    );
  }
}
