import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
Widget customDrawer (BuildContext context){
  return SizedBox(
    width: MediaQuery.of(context).size.width/2,
    height: MediaQuery.of(context).size.height,
    child: Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20.0),
              child: Text(
              'Menu',style: TextStyle(fontSize: 25),
              ),
            ),
            ElevatedButton(
            child: Text('Faculties'),
              onPressed: () {
                Navigator.pushNamed(context, '/faculties_page');
              },
            ),
          ],
        ),
      ),
    ),
  );
}