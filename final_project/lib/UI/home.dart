import 'package:final_project/UI/localdb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/services/firestore.dart';
import '/widgets/navigationbar.dart';
import '../../widgets/drawer.dart';
import '../widgets/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  Future? student = FireStore().getStudent();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: student,
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
            appBar: customAppBar(context),
            drawer: customDrawer(context),
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
                      Text(
                        "Name",
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        capitalize(snapShot.data["name"]) +
                            " " +
                            capitalize(snapShot.data["surname"]) +
                            '\n',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "Student ID",
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        snapShot.data["id"] + '\n',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "Department",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        snapShot.data["department"].toString() + '\n',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "GPA",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        snapShot.data["gpa"].toString() + '\n',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LocalDB()));
              },
              label: const Text(
                'Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
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
