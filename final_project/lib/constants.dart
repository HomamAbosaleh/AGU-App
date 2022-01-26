class Constants {
  static String myName = '';
  static String? uid = '';
  static bool loggedout = false;

  static setUpConstants(name, uid) async {
    Constants.myName = name;
    Constants.uid = uid;
  }

  static void clear() {
    Constants.myName = '';
    Constants.uid = '';
    loggedout = false;
  }
}
