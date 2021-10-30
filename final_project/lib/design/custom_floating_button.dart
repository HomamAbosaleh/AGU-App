import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
