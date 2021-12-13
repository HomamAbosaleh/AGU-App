import 'package:flutter/material.dart';

Widget customFloatingButton(BuildContext context) {
  return SizedBox(
    height: 65.0,
    width: 65.0,
    child: FittedBox(
      child: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.school,
        ),
      ),
    ),
  );
}
