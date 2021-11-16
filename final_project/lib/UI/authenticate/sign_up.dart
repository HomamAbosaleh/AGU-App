import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/fireauth.dart';
import '../../services/firestore.dart';
import '../../model/student.dart';

class SignUp extends StatefulWidget {
  VoidCallback changeSignIn;

  SignUp({Key? key, required this.changeSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? faculty;
  final faculties = [
    'Engineering',
    'Architecture',
    'Managerial Sciences',
    'Humanities and Social Sciences',
    'Life and Natural Science'
  ];
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _id = TextEditingController();
  final _email = TextEditingController(text: '');
  final _department = TextEditingController();
  final _semester = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirmation = TextEditingController();
  bool eye = true;
  Icon eyeIcon = Icon(Icons.remove_red_eye_outlined);
  static const domain = '@agu.edu.tr';

  @override
  Widget build(BuildContext context) {
    Student s;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              controller: _name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
              ],
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Name',
              ),
              onChanged: (name) {
                if (name == '') {
                  _email.text = '';
                } else {
                  _email.text = name + '.' + _surname.text + domain;
                }
              },
            ),
            TextField(
              controller: _surname,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
              ],
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Surname',
              ),
              onChanged: (surname) {
                _email.text = _name.text + '.' + surname + domain;
              },
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
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
                value: faculty,
                iconSize: 24,
                elevation: 1,
                underline: Container(
                  height: 1,
                  color: Color(0xFFD00001),
                ),
                onChanged: (value) => setState(() => faculty = value),
                items: faculties.map(buildMenuItem).toList(),
                hint: const Text(
                  "Faculty",
                  style: TextStyle(
                    color: Color(0xFFD00001),
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[1-9]"))
              ],
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Semester',
              ),
            ),
            TextField(
              cursorColor: Color(0xFFA0A0A0),
              obscureText: eye,
              controller: _password,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      eye = !eye;
                      if (eye == true) {
                        eyeIcon = Icon(Icons.remove_red_eye_outlined);
                      } else {
                        eyeIcon = Icon(Icons.remove_red_eye_sharp);
                      }
                    });
                  },
                  icon: eyeIcon,
                  color: Color(0xFFA0A0A0),
                ),
                labelStyle: const TextStyle(
                  color: Color(0xFFA0A0A0),
                ),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Password',
              ),
            ),
            TextField(
              cursorColor: Color(0xFFA0A0A0),
              obscureText: eye,
              controller: _passwordConfirmation,
              decoration: const InputDecoration(
                labelStyle: const TextStyle(
                  color: Color(0xFFA0A0A0),
                ),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Password Confirmation',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_name.text.isEmpty ||
                    _surname.text.isEmpty ||
                    _id.text.isEmpty ||
                    _department.text.isEmpty ||
                    _semester.text.isEmpty ||
                    _password.text.isEmpty ||
                    _passwordConfirmation.text.isEmpty) {
                  print("Please fill in all information");
                } else {
                  if (_passwordConfirmation.text != _password.text) {
                    print("Please check your password");
                  } else {
                    bool signed = await FireAuth().signUp(
                      email: _email.text,
                      password: _password.text,
                    );
                    if (signed) {
                      s = Student(
                          name: _name.text,
                          surname: _surname.text,
                          gpa: 0.00,
                          id: _id.text,
                          email: _email.text,
                          faculty: faculty,
                          department: _department.text,
                          semester: int.parse(_semester.text));
                      FireStore().addStudent(student: s);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    } else {
                      print("Something Went Wrong");
                    }
                  }
                }
              },
              child: const Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                widget.changeSignIn();
              },
              child: Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );
}
