import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController? _userName = TextEditingController();
  TextEditingController? _password = TextEditingController();
  bool rememberMe = false;
  bool eye = true;
  Icon eyeIcon = Icon(Icons.remove_red_eye_outlined);
  static const String domain = "@agu.edu.tr";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: const Color(0x95000000),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: 60,
                width: 60,
                child: Image.asset("images/whiteLessLogo.png")),
            SizedBox(
                height: 250,
                width: 250,
                child: Image.asset("images/whiteName.png")),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: new EdgeInsets.all(30),
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: <Widget>[
                    TextField(
                      cursorColor: Color(0xFFA0A0A0),
                      controller: _userName,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Color(0xFFA0A0A0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD00001))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD00001))),
                        labelText: 'Email',
                        hintText: "name.surname",
                        suffixText: domain,
                      ),
                    ),
                    TextField(
                      cursorColor: Color(0xFFA0A0A0),
                      obscureText: eye,
                      controller: _password,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              eye = !eye;
                              if (eye == true) {
                                eyeIcon = Icon(Icons.remove_red_eye_outlined);
                              } else {
                                eyeIcon = Icon(Icons.remove_red_eye_sharp);
                              }
                            });
                          },
                          icon: eyeIcon,
                          color: Color(0xFFA0A0A0),
                        ),
                        labelStyle: TextStyle(
                          color: Color(0xFFA0A0A0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD00001))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD00001))),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/home', (route) => false);
                            }, //async {
                            //   bool shouldNavigate =
                            //       await signIn(_userName.text + domain, _password.text);
                            //   if (shouldNavigate) {
                            //     Navigator.pushNamedAndRemoveUntil(
                            //         context, '/home', (route) => false);
                            //   }
                            //},
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFD00001)),
                            child: const Text("Sign In"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              rememberMe = !rememberMe;
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                value: rememberMe,
                                activeColor: Color(0xFFD00001),
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Color(0xFFBABABA),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        //  bool shouldNavigate =
                        //  await signUp(_userName.text + domain, _password.text);
                        // if (shouldNavigate) {
                        //
                        // }
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/signUp',
                          (route) => false,
                          arguments: {'username': _userName!.text},
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Color(0xFFBABABA)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
