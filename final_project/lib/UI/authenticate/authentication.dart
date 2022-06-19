import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_cubit.dart';
import '/model/http_exception.dart';
import '/model/student.dart';
import '/services/fireauth.dart';
import '/theme/theme_manager.dart';
import '/widgets/new_dialogbox.dart';
import 'forget_password.dart';
import 'login.dart';
import 'signup.dart';

enum screenState { login, signup, forgPass }

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  AuthenticationState createState() => AuthenticationState();
}

class AuthenticationState extends State<Authentication> {
  screenState _screenState = screenState.login;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  void toggleLogIn(String screen) {
    if (screen == 'signIn') {
      setState(() {
        _screenState = screenState.login;
        _scrollToTop();
      });
    } else if (screen == 'forgPass') {
      setState(() {
        _screenState = screenState.forgPass;
        _scrollToTop();
      });
    } else {
      setState(() {
        _screenState = screenState.signup;
      });
    }
  }

  Future<void> submit(String email, String password, bool rememberMe,
      [Student? student]) async {
    try {
      if (_screenState == screenState.login) {
        await Provider.of<Auth>(context, listen: false).login(
          email,
          password,
          rememberMe,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          email,
          password,
          student!,
        );
      }
      Navigator.pushNamed(context, '/navigationBar');
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      newAlertDialog(
          context, 'An error occurred while authenticating', errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      newAlertDialog(
          context, 'An error occurred while authenticating', errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double notiPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: _screenState == screenState.login ||
                _screenState == screenState.forgPass
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
              child: LogIn(
                changeLogIn: toggleLogIn,
                submit: submit,
              ),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: _screenState == screenState.login ? 0 : width * 2,
              top: 130,
            ),
            AnimatedPositioned(
              child: SignUp(
                changeLogIn: toggleLogIn,
                sController: _scrollController,
                submit: submit,
              ),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: _screenState == screenState.signup ? 0 : width * 2,
              top: 200,
            ),
            AnimatedPositioned(
              child: ForgetPassword(
                changeLogIn: toggleLogIn,
              ),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCirc,
              right: _screenState == screenState.forgPass ? 0 : width * 2,
              top: 220,
            ),
          ],
        ),
      ),
    );
  }
}
