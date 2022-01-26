import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../model/course.dart';
import '../constants.dart';
import '../model/department.dart';
import '../model/faculty.dart';
import '../model/student.dart';
import 'fireauth.dart';

class FireStore {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  // Courses and Faculties
  Future<List<Faculty>> getFaculties() async {
    List<Faculty> f = [];
    await _firebaseFirestore.collection("faculties").get().then((e) {
      for (var element in e.docs) {
        f.add(
          Faculty(
            name: element.id,
            departments: List.generate(
              element.get("Departments").length,
              (index) => Department.withA(element.get("Departments")[index]),
            ),
          ),
        );
      }
    });
    return f;
  }

  Future getAllDepartments() async {
    List<Department> deps = [];
    await _firebaseFirestore.collection("departments").get().then((e) {
      for (var element in e.docs) {
        deps.add(
          Department.withA(element.id.toString()),
        );
      }
    });
    return deps;
  }

  getCourses() async {
    return await _firebaseFirestore.collection('courses').get();
  }

  getCoursesToApprove() async {
    return await _firebaseFirestore.collection('coursesToBeAdded').snapshots();
  }

  Future getCourseToApprove(String uid) async {
    if (uid.isEmpty) {
      return 0;
    }
    final course =
        await _firebaseFirestore.collection('coursesToBeAdded').doc(uid).get();
    return course;
  }

  Future<int> addCourseToBeApproved({required Course course}) async {
    try {
      Map<String, dynamic> courseToBeAdd = {
        'code': course.code,
        'name': course.name,
        'credit': course.credit,
        'ects': course.ects,
        'department': course.department,
        'locations': course.locations,
        'labLocations': course.labLocations,
        'instructors': course.instructors,
        'sentBy': Constants.myName,
        'time': DateTime.now().toString(),
      };
      String uid = Constants.myName + course.code + courseToBeAdd['time'];
      _firebaseFirestore
          .collection('coursesToBeAdded')
          .doc(uid)
          .set(courseToBeAdd);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> removeCourseToBeApproved({required String uid}) async {
    try {
      await _firebaseFirestore.collection("coursesToBeAdded").doc(uid).delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> addCourse({required Course course}) async {
    bool addable = true;
    await _firebaseFirestore.collection('courses').get().then((e) => {
          e.docs.forEach((element) {
            if (element.id == course.code) {
              addable = false;
            }
          })
        });
    if (addable) {
      Map<String, dynamic> courseToBeAdd = {
        'code': course.code,
        'name': course.name,
        'credit': course.credit,
        'ects': course.ects,
        'department': course.department,
        'locations': course.locations,
        'labLocations': course.labLocations,
        'instructors': course.instructors,
      };
      _firebaseFirestore
          .collection('courses')
          .doc(course.code)
          .set(courseToBeAdd);
      return 1;
    } else {
      return 0;
    }
  }

  // Sign Up
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
      'admin': student.admin,
    });
  }

  Future getDepartments(String departmentName) {
    return _firebaseFirestore
        .collection('departments')
        .doc(departmentName)
        .get();
  }

  // Canteen
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

  Future getWeekSchedule() async {
    final now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    String tomorrow = DateFormat('yyyy-MM-dd')
        .format(DateTime(now.year, now.month, now.day + 1));
    String dayAfterTomorrow = DateFormat('yyyy-MM-dd')
        .format(DateTime(now.year, now.month, now.day + 2));
    List weekList = [];
    bool weekEnd = true;
    await _firebaseFirestore.collection("foodMenu").get().then(
      (value) {
        for (var element in value.docs) {
          if (element.data().containsKey(today)) {
            element.data().forEach(
              (key, value) {
                weekList.add({"date": key, ...value});
              },
            );
            weekEnd = false;
          }
        }
      },
    );
    if (weekEnd) {
      await _firebaseFirestore.collection("foodMenu").get().then(
        (value) {
          for (var element in value.docs) {
            if (element.data().containsKey(tomorrow) ||
                element.data().containsKey(dayAfterTomorrow)) {
              element.data().forEach((key, value) {
                weekList.add({"date": key, ...value});
              });
            }
          }
        },
      );
    }
    weekList.sort((a, b) {
      return DateTime.parse(a["date"]).compareTo(DateTime.parse(b["date"]));
    });
    return weekList.isEmpty
        ? null
        : [
            weekEnd,
            weekList,
          ];
  }

  Future getTodayMeal() async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map mealDictionary = {};
    await _firebaseFirestore.collection("foodMenu").get().then((value) {
      for (var element in value.docs) {
        if (element.data().containsKey(date)) {
          mealDictionary = element.get(date);
        }
      }
    });
    return mealDictionary.isEmpty ? null : mealDictionary;
  }

  void addMoney(double newBalance) async {
    await _firebaseFirestore
        .collection('student')
        .doc(Constants.uid)
        .update({'wallet': newBalance});
  }

  // Chatroom
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
