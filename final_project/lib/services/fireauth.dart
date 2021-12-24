import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String get currentUserID => _firebaseAuth.currentUser!.uid;

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "true";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "true";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message!;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> resetPass(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "0";
    } catch (error) {
      return error.toString();
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
}
