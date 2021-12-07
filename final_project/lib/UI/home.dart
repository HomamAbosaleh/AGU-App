import 'package:final_project/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/customtextstyle.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  Future student = FireStore().getStudent();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: student,
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFF181515),
            appBar: customAppBar(context),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: CircleAvatar(
                          radius: 60,
                        ),
                      ),
                      const Text(
                        "Name",
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        capitalize(snapShot.data["name"]) +
                            " " +
                            capitalize(snapShot.data["surname"]) +
                            '\n',
                        style: customTextStyle(),
                      ),
                      const Text(
                        "Student ID",
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        snapShot.data["id"] + '\n',
                        style: customTextStyle(),
                      ),
                      const Text(
                        "Department",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        snapShot.data["department"].toString() + '\n',
                        style: customTextStyle(),
                      ),
                      const Text(
                        "GPA",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        snapShot.data["gpa"].toString() + '\n',
                        style: customTextStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const customBottomBar(),
            // floatingActionButton: customFloatingButton(context),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
