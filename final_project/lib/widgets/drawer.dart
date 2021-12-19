import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/theme/cubit/theme_cubit.dart';
import '../../services/sharedpreference.dart';

Widget customDrawer(BuildContext context) {
  return BlocBuilder<ThemeCubit, bool>(
    builder: (context, state) {
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
                value: state,
                onChanged: (value) {
                  BlocProvider.of<ThemeCubit>(context).toggleTheme(val: value);
                },
              ),
              ElevatedButton(
                child: const Text('SignOut'),
                onPressed: () async {
                  await SharedPreference.signOut();
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
    },
  );
}
