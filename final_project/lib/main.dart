import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UI/authenticate/authentication.dart';
import 'UI/canteen/food_menu.dart';
import 'UI/chat/chatrooms.dart';
import 'UI/chat/search.dart';
import 'UI/faculties and departments/faculties_page.dart';
import 'UI/home.dart';
import 'UI/schedule.dart';
import 'constants.dart';
import 'services/sharedpreference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.myName = await SharedPreference.getUserName();
  Constants.mySurname = await SharedPreference.getUserSurname();
  Constants.email = await SharedPreference.getUserName();
  Constants.uid = await SharedPreference.getUserId();
  Constants.rememberMe = await SharedPreference.getUserLoggedIn();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomePage(),
        '/faculties_page': (context) => const FacultiesPage(),
        '/chat': (context) => const Chat(),
        '/search': (context) => const Search(),
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
            if (Constants.rememberMe == true) {
              return const HomePage();
            } else {
              return const Authentication();
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
}
