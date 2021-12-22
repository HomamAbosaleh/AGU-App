import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '/widgets/navigationbar.dart';
import '/../widgets/dialogbox.dart';
import 'UI/authenticate/new_login.dart';
import 'theme/theme.dart';
import 'theme/cubit/theme_cubit.dart';
import 'UI/courses/courses.dart';
import 'UI/authenticate/authentication.dart';
import 'UI/canteen/food_menu.dart';
import 'UI/chat/chatrooms.dart';
import 'UI/chat/search.dart';
import 'UI/faculties and departments/faculties_page.dart';
import 'UI/home.dart';
import 'UI/canteen/schedule.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.getUpConstants();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(() => runApp(MyApp()), storage: storage);
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (ctx) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp(
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
            },
            theme: state ? darkTheme : lightTheme,
            home: FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return alertDialog(
                      context, "Error", snapshot.error.toString());
                } else if (snapshot.hasData) {
                  if (Constants.rememberMe == true) {
                    return const CustomNavigationBar();
                  } else {
                    return const NewLoginScreen();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
