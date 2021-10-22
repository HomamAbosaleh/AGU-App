import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: Colors.white,
        title: Row(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 60,
                width: 60 ,
                child: Image.asset("images/logo.jpg")

            ),
            SizedBox(
              height: 250,
                width: 250,
                child: Image.asset("images/name.jpg")
            ),


          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        iconSize: 30,
        selectedFontSize: 15,
        selectedItemColor: Colors.red,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood,
            ),
            label: 'food',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on,
              ),
              label: 'classroom/\nbuildings',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.school,
              ),
              label: 'Academic\nRecord'

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded,
              ),
              label: 'Professors'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,
              ),
              label: 'Settings'
          ),
        ],
        onTap: (index){
          setState(() {
            _currIndex=index;
          });
        },
      ),
    );
  }
}
