import 'package:final_project/model/http_exception.dart';
import 'package:final_project/services/new_fireauth.dart';
import 'package:final_project/theme/theme_manager.dart';
import 'package:final_project/widgets/new_dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
            style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: TextField(
              focusNode: focus1,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]"))],
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16,
              ),
              cursorColor: gPrimaryGreyColor,
              controller: _userName,
              decoration: InputDecoration(
                enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                icon: Icon(Icons.email, color: Theme.of(context).colorScheme.surface),
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
                    if (userName.isNotEmpty) {
                      try {
                        await Provider.of<Auth>(context, listen: false)
                            .resetPass(userName + domain);
                        newAlertDialog(
                            context,
                            'Success!',
                            'A mail has been sent to your email!',
                            const Icon(
                              Icons.check,
                              size: 32,
                              color: Colors.white,
                            ),
                            Colors.green);
                      } on HttpException catch (error) {
                        var errorMessage = 'Authentication failed';
                        if (error.toString().contains('EMAIL_NOT_FOUND')) {
                          errorMessage = 'Could not find a user with that email.';
                        }
                        newAlertDialog(
                            context, 'An error occurred while authenticating', errorMessage);
                      } catch (error) {
                        const errorMessage = 'Could not authenticate you. Please try again later.';
                        newAlertDialog(
                            context, 'An error occurred while authenticating', errorMessage);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
            style: ElevatedButton.styleFrom(
              primary: rPrimaryRedColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: !isLoading ? const Text('Send email') : const CircularProgressIndicator(),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Go back'),
          )
        ],
      ),
    );
  }
}
