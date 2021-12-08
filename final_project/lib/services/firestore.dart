import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/department.dart';
import '../model/faculty.dart';
import '../constants.dart';
import '../model/student.dart';
import 'fireauth.dart';

class FireStore {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  Future<List<Faculty>> getFaculties() async {
    List<Faculty> f = [];
    await _firebaseFirestore.collection("faculties").get().then((e) {
      for (var element in e.docs) {
        f.add(
          Faculty(
            name: element.id,
            departments: List.generate(
              element.get("Departments").length,
              (index) => Department(name: element.get("Departments")[index]),
            ),
          ),
        );
      }
    });
    return f;
  }

  Future getDepartments(String departmentName) {
    return _firebaseFirestore
        .collection('departments')
        .doc(departmentName)
        .get();
  }

  createChatRoom(String? chatRoomId, chatRoomMap) {
    _firebaseFirestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUser(String name) async {
    return await _firebaseFirestore
        .collection("student")
        .where("name", isEqualTo: name)
        .get();
  }

  Future getStudent() async {
    return await _firebaseFirestore
        .collection("student")
        .doc(Constants.uid)
        .get();
  }

  getStudentStream() async {
    return await _firebaseFirestore
        .collection("student")
        .doc(Constants.uid)
        .snapshots();
  }

  void addMoney(double newBalance) async {
    await _firebaseFirestore
        .collection('student')
        .doc(Constants.uid)
        .update({'wallet': newBalance});
  }

  void addConversationMessages(String chatRoomId, messageMap) {
    _firebaseFirestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await _firebaseFirestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms() async {
    return await _firebaseFirestore
        .collection("chatRoom")
        .where("users", arrayContains: Constants.myName)
        .snapshots();
  }

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
      'wallet': student.wallet,
    });
  }
}
