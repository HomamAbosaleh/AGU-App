import 'package:final_project/theme/theme_manager.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(BuildContext context) {
  bool state = currentTheme.isDarkTheme;
  return AppBar(
    centerTitle: true,
    toolbarHeight: 85,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
            height: 60,
            width: 60,
            child: Image.asset(
                state ? "images/whiteLessLogo.png" : "images/transparentBackgroundLogo.png")),
        SizedBox(
            height: 250,
            width: 250,
            child: Image.asset(state ? "images/whiteName.png" : "images/transparentName.png")),
      ],
    ),
  );
}
