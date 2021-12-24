import 'package:final_project/services/fireauth.dart';
import 'package:final_project/services/sharedpreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({Key? key}) : super(key: key);

  @override
  _NewLoginScreenState createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final _userName = TextEditingController();
  final _password = TextEditingController();
  bool eye = true;
  Icon eyeIcon = const Icon(Icons.remove_red_eye_outlined);
  static const String domain = "@agu.edu.tr";
  bool rememberMe = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 50,
              right: 25,
              child: Image.asset(
                'images/logo3.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: rSecondaryRedColor),
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]"))],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: rSecondaryRedColor,
                    ),
                    cursorColor: gPrimaryGreyColor,
                    controller: _userName,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: rSecondaryRedColor,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: rSecondaryRedColor,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: const Icon(Icons.email, color: gSecondaryGreyColor),
                      filled: true,
                      //suffixText: domain,
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        color: gPrimaryGreyColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: TextField(
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      color: rSecondaryRedColor,
                    ),
                    cursorColor: gPrimaryGreyColor,
                    obscureText: eye,
                    controller: _password,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: rSecondaryRedColor,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: rSecondaryRedColor,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: const Icon(Icons.vpn_key_sharp, color: gSecondaryGreyColor),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            eye = !eye;
                            if (eye == true) {
                              eyeIcon = const Icon(
                                Icons.remove_red_eye_outlined,
                                color: gPrimaryGreyColor,
                              );
                            } else {
                              eyeIcon = const Icon(
                                Icons.remove_red_eye_sharp,
                                color: gSecondaryGreyColor,
                              );
                            }
                          });
                        },
                        icon: eyeIcon,
                      ),
                      filled: true,
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: gSecondaryGreyColor,
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
                            side: const BorderSide(
                              color: gSecondaryGreyColor,
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
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 16,
                            color: gSecondaryGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_userName.text.isEmpty || _password.text.isEmpty) {
                      showAlertDialog(context, "Cannot Sign In", "Please fill up all information");
                    } else {
                      String shouldNavigate = await FireAuth().signIn(
                        email: _userName.text + domain,
                        password: _password.text,
                      );
                      if (shouldNavigate == "true") {
                        if (rememberMe) {
                          await SharedPreference.saveLoggingIn(true);
                        } else {
                          await SharedPreference.saveLoggingIn(false);
                        }
                        await setUpDate();
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      } else {
                        showAlertDialog(context, "Cannot Sign In", shouldNavigate);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: rPrimaryRedColor),
                  child: const Text("Sign In"),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.baby,
                      size: 30,
                      color: Colors.black,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setUpDate() async {
    await SharedPreference.saveUserName(_userName.text.split(".")[0]);
    await SharedPreference.saveUserId(FireAuth().currentUserID);
    await SharedPreference.saveUserEmail(_userName.text + domain);
    Constants.myName = await SharedPreference.getUserName();
    Constants.email = await SharedPreference.getUserName();
    Constants.uid = await SharedPreference.getUserId();
    Constants.rememberMe = await SharedPreference.getUserLoggedIn();
  }
}
