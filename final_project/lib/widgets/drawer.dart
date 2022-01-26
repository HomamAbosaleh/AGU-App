import 'package:final_project/services/new_fireauth.dart';
import 'package:final_project/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

Widget customDrawer(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 2,
    height: MediaQuery.of(context).size.height,
    child: Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppBar(
            title: const Text("Menu"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          SwitchListTile(
            title: Text(
              "Theme",
              style: Theme.of(context).textTheme.headline2,
            ),
            inactiveThumbColor: Colors.white,
            activeColor: Colors.black,
            value: currentTheme.isDarkTheme,
            onChanged: (value) {
              currentTheme.toggleTheme();
            },
          ),
          ElevatedButton(
            child: const Text('SignOut'),
            onPressed: () async {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
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
  );
}
