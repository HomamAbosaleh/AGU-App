import 'package:final_project/UI/api/apipage.dart';
import 'package:flutter/material.dart';
import '../../services/sharedpreference.dart';
import '../constants.dart';
class customBottomBar extends StatefulWidget {
  const customBottomBar({Key? key}) : super(key: key);

  @override
  _customBottomBarState createState() => _customBottomBarState();
}

class _customBottomBarState extends State<customBottomBar> {
  int bigval=60;
  double defval=35.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50)
        ),
        child: BottomAppBar(
          color: Color(0xF3000000),
          child: Container(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  color: Color(0xFFD7D6D6),
                  iconSize: defval,
                  icon: Icon(Icons.fastfood),
                  onPressed: () {
                    setState(() {
                      defval=30;
                    });
                    Navigator.pushNamed(context, '/food_menu');
                  },
                ),
                IconButton(
                  color: Color(0xFFD7D6D6),
                  iconSize: defval,
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    setState(() {
                      defval=30;
                    });
                    Navigator.pushNamed(context, '/faculties_page');
                  },
                ),
                PopupMenuButton(
                  icon: Icon(Icons.school,color: Color(0xFFD00001),size: 30,),
                  itemBuilder: (context)=>[
                    PopupMenuItem(
                      child: Text("Profile Information"),
                    ),
                    PopupMenuItem(
                      onTap: ()async {
                        await SharedPreference.signOut();
                        Constants.rememberMe = false;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                              (route) => false,
                        );
                      },
                      child: Text("Sign out"),
                    ),
                  ],
                ),

                IconButton(
                  color: Color(0xFFD7D6D6),
                  iconSize: defval, //FFBDBBBB
                  icon: const Icon(Icons.wifi),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (coxntext){
                      return apiPage();
                    }
                    ));
                    setState(() {
                      defval=30;
                    });
                  },
                ),
                IconButton(
                  color: Color(0xFFD7D6D6),
                  iconSize: defval,
                  icon: const Icon(Icons.chat_bubble),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/chat",
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
