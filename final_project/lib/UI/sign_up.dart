import 'package:flutter/material.dart';

import 'package:final_project/model/student.dart';
import 'package:final_project/Net/flutterfire.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final _name = TextEditingController(
        text: arguments['username'].toString().split('.')[0]);
    final _surname = TextEditingController(
        text: arguments['username'].toString().split('.')[1]);
    final _gpa = TextEditingController();
    final _id = TextEditingController();
    final _email = TextEditingController(
        text: arguments['username'].toString() + "@agu.edu.tr");
    final _faculty = TextEditingController();
    final _department = TextEditingController();
    final _status = TextEditingController();
    final _semester = TextEditingController();
    Student s;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              enabled: false,
              controller: _name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            TextField(
              enabled: false,
              controller: _surname,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Surname',
              ),
            ),
            TextField(
              enabled: false,
              controller: _email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _id,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Student ID',
              ),
            ),
            TextField(
              controller: _faculty,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Faculty',
              ),
            ),
            TextField(
              controller: _department,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Department',
              ),
            ),
            TextField(
              controller: _semester,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Semester',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  s = Student(
                      name: _name.text,
                      surname: _surname.text,
                      gpa: 0.00,
                      id: _id.text,
                      email: _email.text,
                      faculty: _faculty.text,
                      department: _department.text,
                      semester: int.parse(_semester.text));
                  addStudent(s);
                },
                child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
