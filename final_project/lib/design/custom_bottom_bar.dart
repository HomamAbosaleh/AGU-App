import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xF3000000),
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              color: Color(0xFFD7D6D6),
              iconSize: 30,
              icon: Icon(Icons.fastfood),
              onPressed: () {
                Navigator.pushNamed(context, '/food_menu');
              },
            ),
            IconButton(
              color: Color(0xFFD7D6D6),
              iconSize: 30,
              icon: const Icon(Icons.location_on, size: 35),
              onPressed: () {
                Navigator.pushNamed(context, '/faculties_page');
              },
            ),
            const SizedBox(
              width: 35,
            ),
            IconButton(
              color: Color(0xFFD7D6D6),
              iconSize: 30, //FFBDBBBB
              icon: const Icon(Icons.people_rounded),
              onPressed: () {},
            ),
            IconButton(
              color: Color(0xFFD7D6D6),
              iconSize: 30,
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
