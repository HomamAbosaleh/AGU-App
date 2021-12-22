import 'package:final_project/UI/authenticate/signup_part.dart';
import 'package:final_project/theme/cubit/theme_cubit.dart';
import 'package:final_project/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'forget_password.dart';
import 'login_part.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({Key? key}) : super(key: key);

  @override
  _NewLoginScreenState createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  var skey = GlobalKey<ScaffoldState>();
  bool isSigningIn = true;
  bool isSigningUp = false;
  bool isForgPass = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double notiPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: skey,
      drawer: customDrawer(context),
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
              duration: Duration(seconds: 1),
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
                  BlocProvider.of<ThemeCubit>(context)
                      .toggleTheme(val: !BlocProvider.of<ThemeCubit>(context).state);
                },
                icon: const Icon(
                  FontAwesomeIcons.adjust,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedPositioned(
              child: LoginPart(changeSignIn: toggleSignin),
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: isSigningIn ? 0 : width * 2,
              top: 180,
            ),
            AnimatedPositioned(
              child: SignupPart(
                changeSignIn: toggleSignin,
                sController: _scrollController,
              ),
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: isSigningUp ? 0 : width * 2,
              top: 200,
            ),
            AnimatedPositioned(
              child: ForgetPassword(
                changeSignIn: toggleSignin,
                sKey: skey,
              ),
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: isForgPass ? 0 : width * 2,
              top: 220,
            ),
          ],
        ),
      ),
    );
  }

  void toggleSignin(String screen) {
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
    _scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.linear);
  }
}
>>>>>>> 6fd5ba5ec3687f0c794db088b3a1279f567c448d
