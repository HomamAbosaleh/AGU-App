import 'package:final_project/UI/main.dart';
import 'package:final_project/design/custom_app_bar.dart';
import 'package:final_project/design/custom_bottom_bar.dart';
import 'package:final_project/design/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181515),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (route) => false,
                  );
                },
                child: Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
      floatingActionButton: CustomFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> signOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
