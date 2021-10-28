import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:final_project/Net/flutterfire.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _userName = TextEditingController();
  final _password = TextEditingController();
  bool? rememberMe = false;
  static const String domain = "@agu.edu.tr";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: const Color(0x95000000),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: 60,
                width: 60,
                child: Image.asset("images/whiteLessLogo.png")),
            SizedBox(
                height: 250,
                width: 250,
                child: Image.asset("images/whiteName.png")),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _userName,
              decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Email',
                hintText: "name.surname",
                suffixText: domain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: _password,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD00001))),
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style:  ElevatedButton.styleFrom(primary: Color(0xFFD00001)),
                    onPressed: () async {
                     // bool shouldNavigate =
                     //      await signIn(_userName.text + domain, _password.text);
                     //  if (shouldNavigate) {
                     //
                     //  }
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    },
                    child: const Text("Sign In"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style:  ElevatedButton.styleFrom(primary: Color(0xFFD00001)),
                    onPressed: () async {
                    //  bool shouldNavigate =
                     //  await signUp(_userName.text + domain, _password.text);
                      // if (shouldNavigate) {
                      //
                      // }
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/signUp',
                            (route) => false,
                        arguments: {'username': _userName.text},
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: CheckboxListTile(
                    checkColor: Color(0xFFFFFFFF),
                    activeColor: Color(0xFFD00001),
                    title: const Text("Remember Me",
                    textScaleFactor: 0.9,),
                    value: rememberMe,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        rememberMe = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
