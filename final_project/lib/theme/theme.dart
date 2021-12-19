import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: const MaterialColor(0xffff0000, <int, Color>{
    50: Color(0xfff0f0f0),
    100: Color(0xffe6e6e6),
    200: Color(0xffdcdcdc),
    300: Color(0xffd2d2d2),
    400: Color(0xffc8c8c8),
    500: Color(0xffbebebe),
    600: Color(0xffb4b4b4),
    700: Color(0xffaaaaaa),
    800: Color(0xffa0a0a0),
    900: Color(0xff969696),
  }),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFD00001),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF6C6969),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    backgroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  disabledColor: const Color(0xff969696),
  shadowColor: const Color(0xff323232),
  hoverColor: const Color(0xff0a0a0a),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFD00001),
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFD00001),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.black,
        fontSize: 16),
    headline2: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.black,
        fontSize: 18),
    headline3: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.black,
        fontSize: 30),
    headline4: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.white,
        fontSize: 20),
    bodyText1: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFFD00001),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  primarySwatch: const MaterialColor(0xffff0000, <int, Color>{
    50: Color(0xff646464),
    100: Color(0xff5a5a5a),
    200: Color(0xff505050),
    300: Color(0xff464646),
    400: Color(0xff323232),
    500: Color(0xff282828),
    600: Color(0xff1e1e1e),
    700: Color(0xff141414),
    800: Color(0xff0a0a0a),
    900: Color(0xff000000),
  }),
  cardColor: const Color(0xff424242),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFD00001),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFD7D6D6),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xF3000000),
  ),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: Color(0x95000000),
  ),
  scaffoldBackgroundColor: const Color(0xFF303030),
  disabledColor: const Color(0xff646464),
  shadowColor: Color(0x95000000), // container
  hoverColor: Colors.white,
  canvasColor: const Color(0xff303030),
  hintColor: Colors.grey,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
    labelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.grey,
        fontSize: 15),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFD00001),
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFD00001),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(const Color(0xffc7c7c7)),
    checkColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.white,
        fontSize: 16),
    headline2: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.white,
        fontSize: 18),
    headline3: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.white,
        fontSize: 30),
    headline4: TextStyle(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: Colors.white,
        fontSize: 18),
    bodyText1: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFFD00001),
    ),
  ),
);
