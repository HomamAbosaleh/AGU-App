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
    },
    {
      "label": "Confirmation Password",
    },
  ];
  final List<TextEditingController> _controller =
      List.generate(6, (index) => TextEditingController());

  signMeUp() {
    if (formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          elevation: 6.0,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field cannot be empty";
                        }
                      },
                      inputFormatters: properties[index]["filter"] ?? [],
                      controller: _controller[index],
                      decoration: InputDecoration(
                          hintText: properties[index]["hint"] ?? "",
                          labelText: properties[index]["label"],
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD00001))),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD00001))),
                          suffixText: properties[index]["suffix"] ?? ""),
                    );
                  },
                ),
                DropdownButton<String>(
                  value: faculty,
                  items: faculties.map(dropDownBuilder).toList(),
                  hint: const Text("Faculty"),
                  onChanged: (value) {
                    setState(() {
                      faculty = value;
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
        TextButton(
          onPressed: () {
            widget.changeSignIn();
          },
          child: const Text('Go back'),
        ),
      ],
    );
  }

  DropdownMenuItem<String> dropDownBuilder(var item) {
    return DropdownMenuItem(value: item.name, child: Text(item.name));
  }
}
