import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication.dart';
import 'faculties_page.dart';
import 'food_menu.dart';
import 'home.dart';
import 'schedule.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  String? uid;
  MyApp({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    checkIfExists();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/home': (context) => const HomePage(),
        //'/signUp': (context) => const SignUp(),
        '/faculties_page': (context) => const FacultiesPage(),
        '/food_menu/schedule': (context) => const Schedule(),
        '/food_menu': (context) => const Food(),
      },
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("You have an error! ${snapshot.error.toString()}");
            return const Text("Something went wrong!");
          } else if (snapshot.hasData) {
            if (uid != null) {
              return HomePage();
            } else {
              return Authentication();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void checkIfExists() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getString('uid');
  }
}
