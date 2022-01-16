import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '/model/department.dart';
import '/model/faculty.dart';
import '/model/student.dart';
import '/services/fireauth.dart';
import '/services/firestore.dart';
import '/theme/theme.dart';
import '/widgets/dialogbox.dart';
import '../../constants.dart';

class SignUp extends StatefulWidget {
  final ScrollController sController;
  final Function changeLogIn;
  const SignUp({Key? key, required this.changeLogIn, required this.sController}) : super(key: key);

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
  final TextEditingController imageController = TextEditingController();
  final List<TextEditingController> controller =
      List.generate(6, (index) => TextEditingController());

  final List<FocusNode> fNodes = List.generate(10, (index) => FocusNode());

  @override
  void dispose() {
    fNodes.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

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
          alertDialog(context, "Incomplete Information", "Please fill in all the fields");
        } else if (controller[_passwordControllerNumber].text !=
            controller[_confPasswordControllerNumber].text) {
          alertDialog(context, "Password Incorrect", "Please check your password");
        } else {
          String signed = await FireAuth().signUp(
            email: controller[_emailControllerNumber].text + domain,
            password: controller[_passwordControllerNumber].text,
          );
          if (signed == "true") {
            Student s = Student(
              name: controller[_nameControllerNumber].text.toLowerCase(),
              surname: controller[_surnameControllerNumber].text.toLowerCase(),
              gpa: 0.00,
              id: controller[_idControllerNumber].text,
              email: controller[_emailControllerNumber].text.toLowerCase() + domain,
              faculty: faculty!.name,
              department: department!.name,
              semester: semester,
              status: status,
              wallet: 0.00,
              admin: false,
            );
            FireStore().addStudent(student: s);
            await setUpDate();
            Navigator.pushNamedAndRemoveUntil(context, '/navigationBar', (route) => false);
          } else {
            alertDialog(context, "Cannot Sign Up", signed);
          }
        }
      } else {
        alertDialog(context, "Incomplete Information", "Student number must be 10 digits");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: faculties,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              controller: widget.sController,
              children: [
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Join us!',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            if (index == 4) {
                              return dropDownList(snapshot, fNodes);
                            } else {
                              return customTextFormField(context, controller, index, fNodes);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            signMeUp(context);
                          },
                          child: const Text("Submit"),
                          style: ElevatedButton.styleFrom(
                            primary: rPrimaryRedColor,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            fNodes.map((element) {
                              element.unfocus();
                            });
                            widget.changeLogIn('signIn');
                          },
                          child: const Text(
                            'Go back',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget dropDownList(AsyncSnapshot snapshot, List<FocusNode> fNodes) {
    List<DropdownMenuItem<int>> semesters = List.generate(
      8,
      (index) => DropdownMenuItem(
        value: index + 1,
        child: Text((index + 1).toString(), style: Theme.of(context).textTheme.headline4),
      ),
    );
    List<DropdownMenuItem<String>> statuses = ["Graduate", "Undergraduate"]
        .map((e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: Theme.of(context).textTheme.headline4,
            )))
        .toList();
    return Column(
      children: [
        const SizedBox(height: 7),
        DropdownButtonFormField<dynamic>(
          focusNode: fNodes[4],
          isExpanded: true,
          value: faculty,
          items: snapshot.data.map<DropdownMenuItem<dynamic>>(dropDownBuilder).toList(),
          hint: Text(
            "Faculty",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ),
          selectedItemBuilder: (BuildContext context) {
            return snapshot.data.map<Widget>((dynamic item) {
              return Text(
                item.name,
                style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
              );
            }).toList();
          },
          iconEnabledColor: Theme.of(context).hoverColor,
          iconDisabledColor: Theme.of(context).iconTheme.color,
          onChanged: (value) {
            setState(() {
              FocusScope.of(context).requestFocus(fNodes[5]);
              department = null;
              faculty = value;
              departments = value.departments;
            });
          },
          dropdownColor: Theme.of(context).colorScheme.onSurface,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<dynamic>(
          focusNode: fNodes[5],
          isExpanded: true,
          value: department,
          items: departments.map<DropdownMenuItem<dynamic>>(dropDownBuilder).toList(),
          hint: Text(
            "Department",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ),
          selectedItemBuilder: (BuildContext context) {
            return departments.map<Widget>((dynamic item) {
              return Text(
                item.name,
                style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
              );
            }).toList();
          },
          iconEnabledColor: Theme.of(context).hoverColor,
          iconDisabledColor: Theme.of(context).iconTheme.color,
          onChanged: (value) {
            FocusScope.of(context).requestFocus(fNodes[6]);
            setState(() {
              department = value;
            });
          },
          dropdownColor: Theme.of(context).colorScheme.onSurface,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<dynamic>(
          focusNode: fNodes[6],
          isExpanded: true,
          value: semester,
          items: semesters,
          hint: Text(
            "Semester",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          selectedItemBuilder: (BuildContext context) {
            return semesters.map<Widget>((dynamic item) {
              return Text(
                item.value.toString(),
                style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
              );
            }).toList();
          },
          iconEnabledColor: Theme.of(context).hoverColor,
          iconDisabledColor: Theme.of(context).iconTheme.color,
          onChanged: (value) {
            FocusScope.of(context).requestFocus(fNodes[7]);
            setState(() {
              semester = value;
            });
          },
          dropdownColor: Theme.of(context).colorScheme.onSurface,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<dynamic>(
          focusNode: fNodes[7],
          isExpanded: true,
          value: status,
          items: statuses,
          hint: Text(
            "Status",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ),
          selectedItemBuilder: (BuildContext context) {
            return statuses.map<Widget>((dynamic item) {
              return Text(
                item.value.toString(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
          iconEnabledColor: Theme.of(context).hoverColor,
          iconDisabledColor: Theme.of(context).iconTheme.color,
          dropdownColor: Theme.of(context).colorScheme.onSurface,
          onChanged: (value) {
            FocusScope.of(context).requestFocus(fNodes[7]);
            setState(() {
              status = value;
            });
          },
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> setUpDate() async {
    await Constants.setUpConstants(
        controller[_emailControllerNumber].text.replaceAll(".", " ").toLowerCase(),
        controller[_emailControllerNumber].text + domain,
        FireAuth().currentUserID,
        rememberMe);
  }

  DropdownMenuItem<dynamic> dropDownBuilder(item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item.name, style: Theme.of(context).textTheme.headline4),
    );
  }
}

Widget customTextFormField(context, controller, int index, List<FocusNode> fNodes) {
  final Map properties = {
    0: {
      "fNode": fNodes[0],
      "nNode": fNodes[1],
      "hint": "Name",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      "controller": controller[0],
    },
    1: {
      "fNode": fNodes[1],
      "nNode": fNodes[2],
      "hint": "Surname",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      "controller": controller[1],
    },
    2: {
      "fNode": fNodes[2],
      "nNode": fNodes[3],
      "Filter": FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]")),
      "suffix": "@agu.edu.tr",
      "hint": "name.surname",
      "controller": controller[2],
    },
    3: {
      "fNode": fNodes[3],
      "nNode": fNodes[4],
      "hint": "Student ID",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      "controller": controller[3],
      "maxLength": LengthLimitingTextInputFormatter(10),
    },
    5: {
      "fNode": fNodes[8],
      "nNode": fNodes[9],
      "hint": "Password",
      "Filter": FilteringTextInputFormatter.deny(RegExp(" ")),
      "controller": controller[4],
    },
    6: {
      "fNode": fNodes[9],
      "hint": "Confirmation Password",
      "Filter": FilteringTextInputFormatter.deny(RegExp(" ")),
      "controller": controller[5],
    },
  };

  return Column(
    children: [
      const SizedBox(height: 7),
      TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(properties[index]["nNode"]);
        },
        focusNode: properties[index]["fNode"],
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: Theme.of(context).colorScheme.primary,
        obscureText: index >= 5 ? true : false,
        inputFormatters: [
          properties[index]["Filter"],
          properties[index]["maxLength"] ?? LengthLimitingTextInputFormatter(100),
        ],
        controller: properties[index]["controller"],
        decoration: InputDecoration(
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            hintText: properties[index]["hint"],
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondaryVariant,
              fontWeight: FontWeight.w400,
            ),
            suffixText: properties[index]["suffix"] ?? ""),
      ),
    ],
  );
}
