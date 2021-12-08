import 'package:final_project/UI/api/apipage.dart';
import 'package:flutter/material.dart';
import '../../services/sharedpreference.dart';
import '../constants.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int bigval = 60;
  double defval = 35.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50)),
        child: BottomAppBar(
          color: const Color(0xF3000000),
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  color: const Color(0xFFD7D6D6),
                  iconSize: defval,
                  icon: const Icon(Icons.fastfood),
                  onPressed: () {
                    setState(() {
                      defval = 30;
                    });
                    Navigator.pushNamed(context, '/food_menu');
                  },
                ),
                IconButton(
                  color: const Color(0xFFD7D6D6),
                  iconSize: defval,
                  icon: const Icon(Icons.school),
                  onPressed: () {
                    setState(() {
                      defval = 30;
                    });
                    Navigator.pushNamed(context, '/faculties_page');
                  },
                ),
                PopupMenuButton(
                  icon: const Icon(
                    Icons.people,
                    color: Color(0xFFD00001),
                    size: 30,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Profile Information"),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        await SharedPreference.signOut();
                        Constants.rememberMe = false;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text("Sign out"),
                    ),
                  ],
                ),
                IconButton(
                  color: const Color(0xFFD7D6D6),
                  iconSize: defval, //FFBDBBBB
                  icon: const Icon(Icons.wifi),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (coxntext) {
                      return const apiPage();
                    }));
                    setState(() {
                      defval = 30;
                    });
                  },
                ),
                IconButton(
                  color: const Color(0xFFD7D6D6),
                  iconSize: defval,
                  icon: const Icon(Icons.chat_bubble),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/chat",
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
