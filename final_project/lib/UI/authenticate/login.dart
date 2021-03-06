import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:final_project/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum authMode { signup, login }

class LogIn extends StatefulWidget {
  final Function changeLogIn;
  final Function submit;
  const LogIn({Key? key, required this.changeLogIn, required this.submit})
      : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _userName = TextEditingController();
  final _password = TextEditingController();

  static const String domain = "@agu.edu.tr";
  bool rememberMe = false;

  bool eye = true;
  Icon eyeIcon = const Icon(Icons.remove_red_eye_outlined);

  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();

  bool isLoading = false;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _streamSubscription;
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    focus1.dispose();
    focus2.dispose();
    super.dispose();
  }

  void fix(BuildContext context) {
    if (eye == true) {
      setState(() {
        eyeIcon = Icon(
          Icons.remove_red_eye_outlined,
          color: Theme.of(context).colorScheme.surface,
        );
      });
    } else {
      setState(() {
        eyeIcon = Icon(
          Icons.remove_red_eye_sharp,
          color: Theme.of(context).colorScheme.surface,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fix(context);
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_connectivityResult.toString() == "ConnectivityResult.wifi")
              const Icon(Icons.wifi, size: 35),
            if (_connectivityResult.toString() == "ConnectivityResult.mobile")
              const Icon(Icons.wifi, size: 35),
            if (_connectivityResult.toString() == "ConnectivityResult.none")
              const Icon(Icons.wifi_off, size: 35),
            Text(
              'Login',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter your username';
                  }
                },
                focusNode: focus1,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]"))
                ],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16,
                ),
                cursorColor: gPrimaryGreyColor,
                controller: _userName,
                decoration: InputDecoration(
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  icon: Icon(Icons.email,
                      color: Theme.of(context).colorScheme.surface),
                  filled: true,
                  suffixText: domain,
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter your password';
                  }
                },
                focusNode: focus2,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16,
                ),
                cursorColor: gPrimaryGreyColor,
                obscureText: eye,
                controller: _password,
                decoration: InputDecoration(
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  icon: Icon(Icons.vpn_key_sharp,
                      color: Theme.of(context).colorScheme.surface),
                  suffixIcon: IconButton(
                    onPressed: () {
                      eye = !eye;
                      fix(context);
                    },
                    icon: eyeIcon,
                  ),
                  filled: true,
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    rememberMe = !rememberMe;
                  });
                },
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        shape: const CircleBorder(),
                        checkColor: Colors.white,
                        value: rememberMe,
                        activeColor: rPrimaryRedColor,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        focus1.unfocus();
                        focus2.unfocus();
                        widget.changeLogIn('forgPass');
                      },
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    focus1.unfocus();
                    focus2.unfocus();
                    if (_formKey.currentState!.validate()) {
                      widget.submit(
                          _userName.text + domain, _password.text, rememberMe);
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: rPrimaryRedColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Sign In"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    focus1.unfocus();
                    focus2.unfocus();
                    widget.changeLogIn('signUp');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: rPrimaryRedColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Sign Up"),
                ),
              ],
            ),
            const SizedBox(
              height: 45,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/faculties_page');
              },
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.book,
                    size: 76,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Faculties',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
