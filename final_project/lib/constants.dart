import '../../services/sharedpreference.dart';

class Constants {
  static String myName = "";
  static String email = "";
  static String? uid = "";
  static bool? rememberMe = false;

  static getUpConstants() async {
    Constants.myName = await SharedPreference.getUserName();
    Constants.email = await SharedPreference.getUserName();
    Constants.uid = await SharedPreference.getUserId();
    Constants.rememberMe = await SharedPreference.getUserLoggedIn();
  }

  static setUpConstants(name, email, uid, rememberMe) async {
    Constants.myName = name;
    Constants.email = email;
    Constants.uid = uid;
    Constants.rememberMe = rememberMe;
  }
}
