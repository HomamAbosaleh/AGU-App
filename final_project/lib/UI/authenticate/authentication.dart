import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';
import '../../widgets/drawer.dart';
import 'new_login.dart';

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
      drawer: customDrawer(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewLoginScreen()));
                    },
                    child: Text('test')),
                // inSignIn
                //     ? LogIn(
                //         changeSignIn: changeSignIn,
                //       )
                //     : SignUp(
                //         changeSignIn: changeSignIn,
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
