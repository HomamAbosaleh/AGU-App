import 'package:cloud_firestore/cloud_firestore.dart';

import 'fireauth.dart';
import 'package:final_project/model/student.dart';

class FireStore {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  Future<void> addStudent({required Student student}) async {
    String uid = FireAuth().currentUserID;
    _firebaseFirestore.collection('student').doc(uid).set({
      'name': '${student.name}',
      'surname': '${student.surname}',
      'email': '${student.email}',
      'id': '${student.id}',
      'status': '${student.status}',
      'gpa': student.gpa,
      'faculty': '${student.faculty}',
      'department': '${student.department}',
      'semester': '${student.semester}',
      'courses': student.courses,
    });
  }
}
