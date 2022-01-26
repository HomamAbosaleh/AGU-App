import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '/widgets/navigationbar.dart';
import 'UI/authenticate/authentication.dart';
import 'UI/canteen/food_menu.dart';
import 'UI/canteen/meal_of_today.dart';
import 'UI/chat/chatrooms.dart';
import 'UI/chat/search.dart';
import 'UI/courses/courses.dart';
import 'UI/faculties and departments/faculties_page.dart';
import 'UI/home.dart';
import 'UI/tasks.dart';
import 'constants.dart';
import 'services/new_fireauth.dart';
import 'theme/theme_manager.dart';
import 'widgets/dialogbox.dart';

void main() async {
  dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: Auth(),
      ),
    ],
    child: Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: currentTheme.currentTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const HomePage(),
          '/faculties_page': (context) => const FacultiesPage(),
          '/chat': (context) => const Chat(),
          '/search': (context) => const Search(),
          '/food_menu/schedule': (context) => const Schedule(),
          '/food_menu': (context) => const Food(),
          '/courseSchedule': (context) => const CourseSchedule(),
          '/navigationBar': (context) => const CustomNavigationBar(),
          '/tasks': (context) => const Tasks(),
        },
        home: MyApp(auth: auth),
      ),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.auth}) : super(key: key);
  final Auth auth;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      Future.delayed(const Duration(seconds: 15), _cleanAllCache);
    }
    if (state == AppLifecycleState.resumed && Constants.loggedout) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
    super.didChangeAppLifecycleState(state);
  }

  void _cleanAllCache() async {
    Auth().logout();
    Constants.loggedout = true;
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return alertDialog(context, "Error", snapshot.error.toString());
        } else if (snapshot.hasData) {
          bool isLog = Constants.loggedout;
          if (widget.auth.isAuth && !isLog) {
            return const CustomNavigationBar();
          } else {
            return FutureBuilder(
              future: widget.auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                      : const Authentication(),
            );
          }
        } else {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
