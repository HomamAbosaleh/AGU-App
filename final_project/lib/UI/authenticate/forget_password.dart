import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/services/fireauth.dart';
import '/theme/theme.dart';

class ForgetPassword extends StatefulWidget {
  final Function changeLogIn;
  const ForgetPassword({Key? key, required this.changeLogIn}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _userName = TextEditingController();

  static const String domain = "@agu.edu.tr";
  bool isLoading = false;
  FocusNode focus1 = FocusNode();

  @override
  void dispose() {
    focus1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(
            'Forgot Password?',
            style:
                Theme.of(context).textTheme.headline5!.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: TextField(
              focusNode: focus1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]"))
              ],
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onSecondary,
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
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (isLoading)
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    String userName = _userName.text.toLowerCase();
                    focus1.unfocus();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (userName.isNotEmpty) {
                      var output =
                          await FireAuth().resetPass(userName + domain);
                      if (output == "0") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            '✔ Success: A mail has been sent to your email',
                            style: TextStyle(fontSize: 20),
                          ),
                          duration: Duration(seconds: 8),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            '❌ Error: Invalid username!',
                            style: TextStyle(fontSize: 20),
                          ),
                          duration: Duration(seconds: 8),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          '❌ Error: Please enter your username!',
                          style: TextStyle(fontSize: 20),
                        ),
                        duration: Duration(seconds: 8),
                      ));
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
            style: ElevatedButton.styleFrom(
              primary: rPrimaryRedColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: !isLoading
                ? const Text('Send email')
                : const CircularProgressIndicator(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              focus1.unfocus();
              widget.changeLogIn('signIn');
            },
            style: ElevatedButton.styleFrom(
              primary: rPrimaryRedColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Go back'),
          )
        ],
      ),
    );
  }
}
