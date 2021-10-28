import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:final_project/model/student.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<void> addStudent(Student s) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance.collection('student').doc(uid).set({
    'name': '${s.name}',
    'surname': '${s.surname}',
    'email': '${s.email}',
    'id': '${s.id}',
    'status': '${s.status}',
    'gpa': s.gpa,
    'faculty': '${s.faculty}',
    'department': '${s.department}',
    'semester': '${s.semester}',
    'courses': s.courses,
  });
}
