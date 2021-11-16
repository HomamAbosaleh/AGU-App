import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/services/sharedpreference.dart';

import '../model/department.dart';
import '../model/student.dart';
import '../model/faculty.dart';
import 'fireauth.dart';

class FireStore {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  List<Faculty> getFaculties() {
    List<Faculty> f = [];
    _firebaseFirestore.collection("faculties").get().then((element) {
      for (var element in element.docs) {
        Faculty ff = Faculty(
            name: element.id,
            departments: List.generate(element["Departments"].length,
                (index) => Department(name: element["Departments"][index])));
        f.add(ff);
      }
    });
    return f;
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
    return await _firebaseFirestore.collection("chatRoom").snapshots();
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
    });
  }
}
