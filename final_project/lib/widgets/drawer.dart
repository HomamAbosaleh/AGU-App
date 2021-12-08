import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Widget customDrawer(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 2,
    height: MediaQuery.of(context).size.height,
    child: Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 25),
              ),
            ),
            ElevatedButton(
              child: const Text('Faculties'),
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
