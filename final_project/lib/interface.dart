import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: const <Widget>[
            Image(
              image: NetworkImage(
                'http://www.agu.edu.tr/site/tpl/microsites/agu/images/logo.png',
                scale: 0.75,
              ),
            ),
          ],
        ),
        toolbarHeight: 85,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: Colors.red, size: 40),
        selectedItemColor: Colors.red,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: IconThemeData(
          color: Colors.blue,
        ),
        unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fastfood,
              color: Colors.red,
            ),
            label: 'food',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.business,
              ),
              label: 'classroom/\nbuildings'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.school,
              ),
              label: 'Academic\nRecord'),
        ],
      ),
    );
  }
}
