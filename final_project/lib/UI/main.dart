import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'authentication.dart';
import 'home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routes: {
          '/home': (context) => const HomePage(),
        },
        theme: ThemeData.dark(
        ),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot){
            if(snapshot.hasError) {
              print("You have an error! ${snapshot.error.toString()}");
              return const Text("Something went wrong!");
            } else if(snapshot.hasData){
              return Authentication();
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }
}
