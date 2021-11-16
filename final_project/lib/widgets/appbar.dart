import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 85,
    backgroundColor: Color(0x95000000),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
            height: 60,
            width: 60,
            child: Image.asset("images/whiteLessLogo.png")),
        SizedBox(
            height: 250,
            width: 250,
            child: Image.asset("images/whiteName.png")),
      ],
    ),
  );
}
