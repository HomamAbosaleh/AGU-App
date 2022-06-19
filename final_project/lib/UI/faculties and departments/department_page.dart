import 'package:flutter/material.dart';

import 'professors.dart';

class DepartmentPage extends StatefulWidget {
  final String departmentName;
  final String facultyName;
  const DepartmentPage(
      {Key? key, required this.facultyName, required this.departmentName})
      : super(key: key);

  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.departmentName),
        centerTitle: true,
      ),
      body: Professors(
        facultyName: widget.facultyName,
        departmentName: widget.departmentName,
      ),
    );
  }
}
