import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../services/fireauth.dart';
import '/../services/firestore.dart';
import '/../model/department.dart';
import '/../model/faculty.dart';
import '/../widgets/alertdialog.dart';
import '/../model/student.dart';

class SignUp extends StatefulWidget {
  final VoidCallback changeSignIn;
  const SignUp({Key? key, required this.changeSignIn}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  Faculty? faculty;
  Department? department;
  int? semester;
  String? status;
  List<Department> departments = [];
  final faculties = FireStore().getFaculties();
  final List<TextEditingController> controller =
      List.generate(6, (index) => TextEditingController());

  signMeUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (faculty == null ||
          department == null ||
          semester == null ||
          status == null) {
        showAlertDialog(context, "Incomplete Information",
            "Please fill in all information");
      } else if (controller[4].text != controller[5].text) {
        showAlertDialog(
            context, "Password Incorrect", "Please check your password");
      } else {
        String signed = await FireAuth().signUp(
          email: controller[2].text + "@agu.edu.tr",
          password: controller[4].text,
        );
        if (signed == "true") {
          Student s = Student(
              name: controller[0].text,
              surname: controller[1].text,
              gpa: 0.00,
              id: controller[3].text,
              email: controller[2].text + "@agu.edu.tr",
              faculty: faculty!.name,
              department: department!.name,
              semester: semester,
              status: status);
          FireStore().addStudent(student: s);
          await setUpDate();
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          showAlertDialog(context, "Cannot Sign Up", signed);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: faculties,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Card(
                elevation: 6.0,
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            if (index == 4) {
                              return dropDownList(snapshot);
                            } else {
                              return customTextFormField(controller, index);
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              signMeUp(context);
                            },
                            child: const Text("Submit")),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.changeSignIn();
                },
                child: const Text('Go back',style: TextStyle(color: Colors.red),),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget dropDownList(AsyncSnapshot snapshot) {
    return Column(
      children: [
        DropdownButton<dynamic>(
          isExpanded: true,
          value: faculty,
          items: snapshot.data
              .map<DropdownMenuItem<dynamic>>(dropDownBuilder)
              .toList(),
          hint: const Text("Faculty"),
          onChanged: (value) {
            setState(() {
              department = null;
              faculty = value;
              departments = value.departments;
            });
          },
        ),
        DropdownButton<dynamic>(
          isExpanded: true,
          value: department,
          items: departments
              .map<DropdownMenuItem<dynamic>>(dropDownBuilder)
              .toList(),
          hint: const Text("Department"),
          onChanged: (value) {
            setState(() {
              department = value;
            });
          },
        ),
        DropdownButton<dynamic>(
          isExpanded: true,
          value: semester,
          items: List.generate(
            8,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text((index + 1).toString()),
            ),
          ),
          hint: const Text("Semester"),
          onChanged: (value) {
            setState(() {
              semester = value;
            });
          },
        ),
        DropdownButton<dynamic>(
          isExpanded: true,
          value: status,
          items: ["Graduate", "Undergraduate"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          hint: const Text("Status"),
          onChanged: (value) {
            setState(() {
              status = value;
            });
          },
        ),
      ],
    );
  }

  Future<void> setUpDate() async {
    Constants.myName = controller[0].text;
    Constants.email = controller[2].text + "@agu.edu.tr";
    Constants.uid = await FireAuth().currentUserID;
    Constants.rememberMe = false;
  }
}

DropdownMenuItem<dynamic> dropDownBuilder(item) {
  return DropdownMenuItem(value: item, child: Text(item.name));
}

Widget customTextFormField(controller, int index) {
  final Map properties = {
    0: {
      "label": "Name",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      "controller": controller[0],
    },
    1: {
      "label": "Surname",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      "controller": controller[1],
    },
    2: {
      "label": "Email",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]")),
      "suffix": "@agu.edu.tr",
      "hint": "name.surname",
      "controller": controller[2],
    },
    3: {
      "label": "Student ID",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      "controller": controller[3],
      "maxLength": 10,
    },
    5: {
      "label": "Password",
      "Filter": FilteringTextInputFormatter.deny(RegExp(" ")),
      "controller": controller[4],
    },
    6: {
      "label": "Confirmation Password",
      "Filter": FilteringTextInputFormatter.deny(RegExp(" ")),
      "controller": controller[5],
    },
  };
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "This field cannot be empty";
      }
    },
    maxLength: properties[index]["maxLength"],
    cursorColor: const Color(0xFFA0A0A0),
    obscureText: index >= 5 ? true : false,
    inputFormatters: [properties[index]["Filter"]],
    controller: properties[index]["controller"],
    decoration: InputDecoration(
        hintText: properties[index]["hint"] ?? "",
        labelText: properties[index]["label"],
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD00001))),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD00001))),
        suffixText: properties[index]["suffix"] ?? ""),
  );
}
