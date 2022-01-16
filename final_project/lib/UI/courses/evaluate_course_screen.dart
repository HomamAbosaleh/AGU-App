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
        builder: (BuildContext cxt, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                'No courses to approve!',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to remove this course from approval?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("REMOVE")),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text("Are you sure you wish to approve this course?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("APPROVE")),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      int result = await FireStore()
                          .removeCourseToBeApproved(uid: snapshot.data.docs[index].id);
                      if (result == 1) {
                        ScaffoldMessenger.of(cxt).showSnackBar(
                            const SnackBar(content: Text("Course removed successfully!")));
                      } else {
                        ScaffoldMessenger.of(cxt)
                            .showSnackBar(const SnackBar(content: Text("Something went wrong!")));
                      }
                    } else {
                      Course courseToAdd = Course(
                          code: snapshot.data.docs[index]['code'],
                          name: snapshot.data.docs[index]['name'],
                          credit: snapshot.data.docs[index]['credit'],
                          ects: snapshot.data.docs[index]['ects'],
                          locations: snapshot.data.docs[index]['locations'],
                          instructors: snapshot.data.docs[index]['instructors'],
                          labLocations: snapshot.data.docs[index]['labLocations'],
                          department: snapshot.data.docs[index]['department']);
                      int result = await FireStore().addCourse(course: courseToAdd);
                      if (result == 1) {
                        ScaffoldMessenger.of(cxt).showSnackBar(
                            const SnackBar(content: Text("Course approved successfully!")));
                        await FireStore()
                            .removeCourseToBeApproved(uid: snapshot.data.docs[index].id);
                      } else {
                        ScaffoldMessenger.of(cxt)
                            .showSnackBar(const SnackBar(content: Text("Something went wrong!")));
                      }
                    }
                    setState(() {});
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white, size: 40),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 15),
                  ),
                  child: InkWell(
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
