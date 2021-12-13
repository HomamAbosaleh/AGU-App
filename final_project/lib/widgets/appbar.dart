import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/theme/cubit/theme_cubit.dart';

PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    toolbarHeight: 85,
    title: BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(state
                    ? "images/whiteLessLogo.png"
                    : "images/transparentBackgroundLogo.png")),
            SizedBox(
                height: 250,
                width: 250,
                child: Image.asset(state
                    ? "images/whiteName.png"
                    : "images/transparentName.png")),
          ],
        );
      },
    ),
  );
}
