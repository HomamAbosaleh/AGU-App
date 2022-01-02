import 'package:final_project/model/course.dart';
import 'package:final_project/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_course_screen.dart';

class EvaluateCourseScreen extends StatefulWidget {
  const EvaluateCourseScreen({Key? key}) : super(key: key);

  @override
  _EvaluateCourseScreenState createState() => _EvaluateCourseScreenState();
}

class _EvaluateCourseScreenState extends State<EvaluateCourseScreen> {
  Stream? _coursesStream;

  @override
  void initState() {
    FireStore().getCoursesToApprove().then((value) {
      setState(() {
        _coursesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses to add'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _coursesStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.length == 0) {
            return const Center(
              child: Text(
                'No courses to approve!',
                style: TextStyle(fontSize: 36),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCourseScreen(
                          admin: true,
                          courseUID: snapshot.data.docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Course.withA().getIcon(snapshot.data.docs[index]["department"]),
                      size: 40,
                    ),
                    title: Text(snapshot.data.docs[index]["code"]),
                    subtitle: Text(snapshot.data.docs[index]["name"]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
