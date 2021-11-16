import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/firestore.dart';

class SignUp extends StatefulWidget {
  final VoidCallback changeSignIn;
  const SignUp({Key? key, required this.changeSignIn}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  String? faculty;
  String? department;
  List departments = [];
  final faculties = FireStore().getFaculties();
  final List properties = [
    {
      "label": "Name",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
    },
    {
      "label": "Surname",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
    },
    {
      "label": "Email",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]")),
      "suffix": "@agu.edu.tr",
      "hint": "name.surname",
    },
    {
      "label": "Student ID",
      "Filter": FilteringTextInputFormatter.allow(RegExp("[0-9]"))
    },
    {
      "label": "Password",
      "Filter": FilteringTextInputFormatter.deny(RegExp(" "))
    },
    {
      "label": "Confirmation Password",
      "Filter": FilteringTextInputFormatter.deny(RegExp(" "))
    },
  ];
  final List<TextEditingController> _controller =
      List.generate(6, (index) => TextEditingController());

  signMeUp() {
    if (formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: faculties,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 6.0,
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field cannot be empty";
                                }
                              },
                              inputFormatters: [properties[index]["Filter"]],
                              controller: _controller[index],
                              decoration: InputDecoration(
                                  hintText: properties[index]["hint"] ?? "",
                                  labelText: properties[index]["label"],
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFD00001))),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFD00001))),
                                  suffixText:
                                      properties[index]["suffix"] ?? ""),
                            );
                          },
                        ),
                        DropdownButton<String>(
                          value: faculty,
                          items: snapshot.data.docs
                              .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem<String>(
                                  value: e.id,
                                  child: Text(e.id),
                                ),
                              )
                              .toList(),
                          hint: const Text("Faculty"),
                          onChanged: (value) {
                            department = null;
                            for (var element in snapshot.data.docs) {
                              if (element.id == value) {
                                setState(() {
                                  faculty = value;
                                  departments = element["Departments"];
                                });
                                break;
                              }
                            }
                          },
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: department,
                          items: departments
                              .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          hint: const Text("Department"),
                          onChanged: (value) {
                            setState(() {
                              department = value;
                            });
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              signMeUp();
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
                child: const Text('Go back'),
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
}
