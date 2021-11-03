import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final AppBar appBar = AppBar();
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height + 25);
}
