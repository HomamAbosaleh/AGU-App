import 'package:flutter/material.dart';


import 'package:final_project/Net/flutterfire.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  State<SignIn> createState() => _SignInState();

}

class _SignInState extends State<SignIn>{
    final userName = TextEditingController();
    final password = TextEditingController();
    static const String domain = "@agu.edu.tr";
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 85,
          backgroundColor: Color(0x95000000),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                  height: 60,
                  width: 60 ,
                  child: Image.asset("images/whitelessLogo.png")
              ),
              SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset("images/whiteName.png")
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                TextField(controller: userName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: "name.surname",
                    suffixText: domain,
                  ),
                ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
            ),
            ElevatedButton(onPressed: () async {
              bool shouldNavigate = await signUp(userName.text + domain, password.text);
              if (shouldNavigate) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              }
            }, child: const Text("Sign In")),
          ],
        ),
      );
    }
}