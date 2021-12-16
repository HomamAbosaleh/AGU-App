import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../services/sharedpreference.dart';
import '../../services/fireauth.dart';
import '/../widgets/dialogbox.dart';

class LogIn extends StatefulWidget {
  VoidCallback changeSignIn;

  LogIn({Key? key, required this.changeSignIn}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _userName = TextEditingController();
  final _password = TextEditingController();
  bool rememberMe = false;
  bool eye = true;
  Icon eyeIcon = const Icon(Icons.remove_red_eye_outlined);
  static const String domain = "@agu.edu.tr";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.headline1,
            cursorColor: const Color(0xFFA0A0A0),
            controller: _userName,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]"))
            ],
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color(0xFFA0A0A0),
              ),
              labelText: 'Email',
              hintText: "name.surname",
              suffixText: domain,
            ),
          ),
          TextField(
            style: Theme.of(context).textTheme.headline1,
            cursorColor: const Color(0xFFA0A0A0),
            obscureText: eye,
            controller: _password,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    eye = !eye;
                    if (eye == true) {
                      eyeIcon = const Icon(Icons.remove_red_eye_outlined);
                    } else {
                      eyeIcon = const Icon(Icons.remove_red_eye_sharp);
                    }
                  });
                },
                icon: eyeIcon,
                color: const Color(0xFFA0A0A0),
              ),
              labelStyle: const TextStyle(
                color: Color(0xFFA0A0A0),
              ),
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_userName.text.isEmpty || _password.text.isEmpty) {
                      alertDialog(context, "Cannot Sign In",
                          "Please fill up all information");
                    } else {
                      String shouldNavigate = await FireAuth().signIn(
                        email: _userName.text + domain,
                        password: _password.text,
                      );
                      if (shouldNavigate == "true") {
                        await SharedPreference.saveLoggingIn(rememberMe);
                        await setUpDate();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      } else {
                        alertDialog(context, "Cannot Sign In", shouldNavigate);
                      }
                    }
                  },
                  child: const Text("Sign In"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    rememberMe = !rememberMe;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      activeColor: const Color(0xFFD00001),
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Color(0xFFBABABA),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              widget.changeSignIn();
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Color(0xFFBABABA)),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> setUpDate() async {
    await SharedPreference.saveUserName(
        _userName.text.replaceAll(".", " ").toLowerCase());
    await SharedPreference.saveUserId(FireAuth().currentUserID);
    await SharedPreference.saveUserEmail(_userName.text.toLowerCase() + domain);
    Constants.getUpConstants();
  }
}
