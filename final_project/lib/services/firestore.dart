import 'package:cloud_firestore/cloud_firestore.dart';

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

  void createChatRoom(sendToName, chatRoomMap, sendToChatRoomMap) async {
    var sendToId;
    await _firebaseFirestore.collection("student").get().then(
      (value) {
        for (var element in value.docs) {
          if ((element["name"] + " " + element["surname"]) == sendToName) {
            sendToId = element.id;
            break;
          }
        }
      },
    );
    _firebaseFirestore
        .collection("student")
        .doc(Constants.uid)
        .collection("chatRooms")
        .doc(sendToName)
        .set(chatRoomMap);
    _firebaseFirestore
        .collection("student")
        .doc(sendToId)
        .collection("chatRooms")
        .doc(Constants.myName)
        .set(sendToChatRoomMap);
  }

  void deleteChatRoom(snapshot) async {
    _firebaseFirestore
        .collection("student")
        .doc(Constants.uid)
        .collection("chatRooms")
        .doc(snapshot.id)
        .collection("chats")
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
    await _firebaseFirestore.runTransaction((transaction) async {
      transaction.delete(snapshot.reference);
    });
  }

  void addConversationMessages(String chatRoomId, messageMap) async {
    var sendToId;
    await _firebaseFirestore.collection("student").get().then(
      (value) {
        for (var element in value.docs) {
          if ((element["name"] + " " + element["surname"]) == chatRoomId) {
            sendToId = element.id;
            break;
          }
        }
      },
    );
    _firebaseFirestore
        .collection("student")
        .doc(sendToId)
        .collection("chatRooms")
        .doc(Constants.myName)
        .collection("chats")
        .add(messageMap);
    _firebaseFirestore
        .collection("student")
        .doc(Constants.uid)
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap);
  }

  getConversationMessages(String chatRoomId) async {
    return await _firebaseFirestore
        .collection("student")
        .doc(Constants.uid)
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms() async {
    return await _firebaseFirestore
        .collection("student")
        .doc(Constants.uid)
        .collection("chatRooms")
        .snapshots();
  }

  getUser() async {
    List<String> l = [];
    await _firebaseFirestore.collection("student").get().then((value) {
      for (var element in value.docs) {
        if ((element["name"] + " " + element["surname"]) != Constants.myName) {
          l.add(element["name"] + " " + element["surname"]);
        }
      }
    });
    l.sort((a, b) {
      return a.compareTo(b);
    });
    return l;
  }
}
