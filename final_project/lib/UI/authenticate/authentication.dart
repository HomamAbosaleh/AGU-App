import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_cubit.dart';
import 'forget_password.dart';
import 'login.dart';
import 'signup.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  AuthenticationState createState() => AuthenticationState();
}

class AuthenticationState extends State<Authentication> {
  bool isSigningIn = true;
  bool isSigningUp = false;
  bool isForgPass = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double notiPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: isSigningIn || isForgPass
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            AnimatedContainer(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/login background.png'),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              height: 1200,
              duration: const Duration(seconds: 1),
            ),
            Positioned(
              top: notiPadding + 20,
              right: 20,
              child: Image.asset(
                'images/whitelogo.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: notiPadding + 20,
              left: 20,
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<ThemeCubit>(context).toggleTheme(
                      val: !BlocProvider.of<ThemeCubit>(context).state);
                },
                icon: BlocBuilder<ThemeCubit, bool>(
                  builder: (context, state) {
                    return Icon(
                      state ? Icons.wb_sunny_sharp : Icons.dark_mode_sharp,
                      size: 40,
                      color: state ? Colors.orangeAccent : Colors.grey,
                    );
                  },
                ),
              ),
            ),
            AnimatedPositioned(
              child: LogIn(changeLogIn: toggleLogIn),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: isSigningIn ? 0 : width * 2,
              top: 180,
            ),
            AnimatedPositioned(
              child: SignUp(
                changeLogIn: toggleLogIn,
                sController: _scrollController,
              ),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: isSigningUp ? 0 : width * 2,
              top: 200,
            ),
            AnimatedPositioned(
              child: ForgetPassword(
                changeLogIn: toggleLogIn,
              ),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: isForgPass ? 0 : width * 2,
              top: 220,
            ),
          ],
        ),
      ),
    );
  }

  void toggleLogIn(String screen) {
    if (screen == 'signIn') {
      setState(() {
        isSigningIn = true;
        isForgPass = false;
        isSigningUp = false;
        _scrollToTop();
      });
    } else if (screen == 'forgPass') {
      setState(() {
        isForgPass = true;
        isSigningIn = false;
        isSigningUp = false;
        _scrollToTop();
      });
    } else {
      setState(() {
        isSigningUp = true;
        isForgPass = false;
        isSigningIn = false;
      });
    }
  }

  late ScrollController _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }
}
