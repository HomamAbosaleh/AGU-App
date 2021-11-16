import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'new_sign_up.dart';
import 'log_in.dart';
import '../../widgets/appbar.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);
  @override
  State<Authentication> createState() => AuthenticationState();
}

class AuthenticationState extends State<Authentication> {
  bool inSignIn = true;
  String signInORUp = 'Sign Up';

  void changeSignIn() {
    setState(() {
      inSignIn = !inSignIn;
      if (!inSignIn) {
        signInORUp = 'Sign In';
      } else {
        signInORUp = 'Sign Up';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              children: [
                inSignIn
                    ? LogIn(
                        changeSignIn: changeSignIn,
                      )
                    : SignUp(
                        changeSignIn: changeSignIn,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
