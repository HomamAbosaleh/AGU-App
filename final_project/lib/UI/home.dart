import 'package:flutter/material.dart';

import '../../services/sharedpreference.dart';
import '../constants.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181515),
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await SharedPreference.signOut();
                  Constants.rememberMe = false;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                child: const Text("Sign Out"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    "/chat",
                  );
                },
                child: const Text("Chat out"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: customBottomBar(context),
      floatingActionButton: customFloatingButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
