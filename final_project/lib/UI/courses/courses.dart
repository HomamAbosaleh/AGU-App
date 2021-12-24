import 'package:final_project/services/firestore.dart';
import 'package:final_project/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'add_course_screen.dart';
import 'evaluate_course_screen.dart';

class CourseSchedule extends StatefulWidget {
  const CourseSchedule({Key? key}) : super(key: key);

  @override
  _CourseScheduleState createState() => _CourseScheduleState();
}

class _CourseScheduleState extends State<CourseSchedule> {
  Future? student = FireStore().getStudent();
  late bool admin;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: student,
        builder: (context, AsyncSnapshot snapShot) {
          if (snapShot.hasData) {
            admin = snapShot.data["admin"];
            return Scaffold(
              drawer: customDrawer(context),
              appBar: AppBar(
                title: const Text('Courses'),
                //centerTitle: true,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCourseScreen(
                              admin: admin,
                            ),
                          ),
                        );
                      },
                      child: Text('Can\'t find your course?'))
                ],
              ),
              body: SingleChildScrollView(
                child: Column(),
              ),
              floatingActionButton: admin
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EvaluateCourseScreen()),
                        );
                      },
                      child: const Icon(
                        FontAwesomeIcons.edit,
                        color: Colors.white,
                      ),
                    )
                  : null,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
