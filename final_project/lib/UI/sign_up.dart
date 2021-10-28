import 'package:flutter/material.dart';

import 'package:final_project/model/student.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue;
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
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Name',
              ),
            ),
            TextField(
              enabled: false,
              controller: _surname,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Surname',
              ),
            ),
            TextField(
              enabled: false,
              controller: _email,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _id,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Student ID',
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                iconSize: 24,
                elevation: 1,
                underline: Container(
                  height: 1,
                  color: Color(0xFFD00001),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Engineering', 'Pyschology', 'Economy', 'Moleculur Biology and Genetics']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint:  Text(
                  "Faculty",
                  style: TextStyle(
                    //color: Color(0xFFD00001),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _department,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Department',
              ),
            ),
            TextField(
              controller: _semester,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
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
                      faculty: _faculty.text,
                      department: _department.text,
                      semester: int.parse(_semester.text));
                },
                child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
