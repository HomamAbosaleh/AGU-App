import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: const <Widget>[
        ],
      ),
    );
  }
}