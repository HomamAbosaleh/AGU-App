import 'package:flutter/material.dart';

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
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: Color(0x95000000),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: 60,
                width: 60 ,
                child: Image.asset("images/whiteLessLogo.png")
            ),
            SizedBox(
                height: 250,
                width: 250,
                child: Image.asset("images/whiteName.png")
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xF3000000),
        shape: CircularNotchedRectangle(),
        child: Container(//
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Color(0xFFD7D6D6),
                iconSize: 30,
                icon: Icon(Icons.fastfood),
                onPressed: (){
                },
              ),
              IconButton(
                color: Color(0xFFD7D6D6),
                iconSize: 30,
                icon: const Icon(Icons.location_on,
                    size:35),
                onPressed: (){
                },
              ),
              const SizedBox(
                width: 35,
              ),
              IconButton(
                color:  Color(0xFFD7D6D6),
                iconSize: 30,//FFBDBBBB
                icon: const Icon(Icons.people_rounded),
                onPressed: (){
                },
              ),
              IconButton(
                color: Color(0xFFD7D6D6),
                iconSize: 30,
                icon: const Icon(Icons.settings),
                onPressed: (){
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Color(0xFFD00001),
            onPressed: () {},
            child: const Icon(
              Icons.school,
              color: Color(0xFFD7D6D6),
            ),
            // elevation: 5.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
            ],
          ),
        ),
      ),
    );
  }
}
