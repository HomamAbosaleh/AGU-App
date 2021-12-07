import 'package:shared_preferences/shared_preferences.dart';
import '../../services/fireauth.dart';

class SharedPreference {
  static String userLoggedInKey = "ISLOGGEDIN";
  static String userNameKey = "USERNAMEKEY";
  static String userSurnameKey = "USERSURNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userId = "USERIDKEY";

  // saving data to sharedPreferences
  static Future<void> saveLoggingIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<void> saveUserId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userId, uid);
  }

  static Future<void> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, userName);
  }

  static Future<void> saveUserSurname(String surname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userSurnameKey, surname);
  }

  static Future<void> saveUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, userEmail);
  }

  // getting data from SharedPreference
  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey) ?? "";
  }

  static Future<String> getUserSurname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userSurnameKey) ?? "";
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FireAuth().signOut();
  }
}
