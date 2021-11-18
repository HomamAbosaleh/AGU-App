import 'package:final_project/services/firestore.dart';
import 'package:flutter/material.dart';

class DepartmentPage extends StatefulWidget {
  String departmentName;

  DepartmentPage({Key? key, required this.departmentName}) : super(key: key);

  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  late Future department;
  @override
  void initState() {
    department = FireStore().getDepartments(widget.departmentName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: department,
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('tiddies'),
            ),
            body: Center(
              child: Column(
                children: [
                  Text(snapShot.data.id),
                ],
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
