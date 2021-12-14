import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../services/fireauth.dart';
import '/../services/firestore.dart';
import '/../model/department.dart';
import '/../model/faculty.dart';
import '/../widgets/dialogbox.dart';
import '/../model/student.dart';

class SignUp extends StatefulWidget {
  final VoidCallback changeSignIn;
  const SignUp({Key? key, required this.changeSignIn}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool rememberMe = false;
  static const String domain = "@agu.edu.tr";
  static const int _nameControllerNumber = 0;
  static const int _surnameControllerNumber = 1;
  static const int _emailControllerNumber = 2;
  static const int _idControllerNumber = 3;
  static const int _passwordControllerNumber = 4;
  static const int _confPasswordControllerNumber = 5;
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
      if (controller[_idControllerNumber].text.length == 10) {
        if (controller[_nameControllerNumber].text.isEmpty ||
            controller[_surnameControllerNumber].text.isEmpty ||
            controller[_emailControllerNumber].text.isEmpty ||
            controller[_idControllerNumber].text.isEmpty ||
            controller[_passwordControllerNumber].text.isEmpty ||
            controller[_confPasswordControllerNumber].text.isEmpty ||
            faculty == null ||
            department == null ||
            semester == null ||
            status == null) {
          alertDialog(context, "Incomplete Information",
              "Please fill in all the fields");
        } else if (controller[_passwordControllerNumber].text !=
            controller[_confPasswordControllerNumber].text) {
          alertDialog(
              context, "Password Incorrect", "Please check your password");
        } else {
          String signed = await FireAuth().signUp(
            email: controller[_emailControllerNumber].text + domain,
            password: controller[_passwordControllerNumber].text,
          );
          if (signed == "true") {
            Student s = Student(
                name: controller[_nameControllerNumber].text.toLowerCase(),
                surname:
                    controller[_surnameControllerNumber].text.toLowerCase(),
                gpa: 0.00,
                id: controller[_idControllerNumber].text,
                email: controller[_emailControllerNumber].text.toLowerCase() +
                    domain,
                faculty: faculty!.name,
                department: department!.name,
                semester: semester,
                status: status,
                wallet: 0.00);
            FireStore().addStudent(student: s);
            await setUpDate();
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else {
            alertDialog(context, "Cannot Sign Up", signed);
          }
        }
      } else {
        alertDialog(context, "Incomplete Information",
            "Student number must be 10 digits");
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
                              return customTextFormField(
                                  context, controller, index);
                            }
                          },
                        ),
                        ElevatedButton(
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
                child: const Text(
                  'Go back',
                  style: TextStyle(color: Colors.red),
                ),
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
        DropdownButtonFormField<dynamic>(
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
        DropdownButtonFormField<dynamic>(
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
        DropdownButtonFormField<dynamic>(
          isExpanded: true,
          value: semester,
          items: List.generate(
            8,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text((index + 1).toString(),
                  style: Theme.of(context).textTheme.headline1),
            ),
          ),
          hint: const Text("Semester"),
          onChanged: (value) {
            setState(() {
              semester = value;
            });
          },
        ),
        DropdownButtonFormField<dynamic>(
          isExpanded: true,
          value: status,
          items: ["Graduate", "Undergraduate"]
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: Theme.of(context).textTheme.headline1,
                  )))
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
    await Constants.setUpConstants(
        controller[_emailControllerNumber]
            .text
            .replaceAll(".", " ")
            .toLowerCase(),
        controller[_emailControllerNumber].text + domain,
        FireAuth().currentUserID,
        rememberMe);
  }

  DropdownMenuItem<dynamic> dropDownBuilder(item) {
    return DropdownMenuItem(
        value: item,
        child: Text(item.name, style: Theme.of(context).textTheme.headline1));
  }
}

Widget customTextFormField(context, controller, int index) {
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
      "maxLength": LengthLimitingTextInputFormatter(10),
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
    style: Theme.of(context).textTheme.headline1,
    focusNode: FocusNode(canRequestFocus: false),
    cursorColor: const Color(0xFFA0A0A0),
    obscureText: index >= 5 ? true : false,
    inputFormatters: [
      properties[index]["Filter"],
      properties[index]["maxLength"] ?? LengthLimitingTextInputFormatter(100),
    ],
    controller: properties[index]["controller"],
    decoration: InputDecoration(
        hintText: properties[index]["hint"] ?? "",
        labelText: properties[index]["label"],
        suffixText: properties[index]["suffix"] ?? ""),
  );
}
