import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../constants.dart';
import '../../services/firestore.dart';
import 'conversation.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> students = [];
  List<String> filteredStudents = [];
  TextEditingController search = TextEditingController();

  what(name) {
    if (name != Constants.myName) {
      String chatRoomId = getChatRoomId(name, Constants.myName);
      List<String> users = [name, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      FireStore().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Conversation(
            chatRoomId: chatRoomId,
          ),
        ),
      );
    } else {
      print("You cannot search for yourself");
    }
  }

  getAllStudents() async {
    await FireStore().getUser().then((value) {
      setState(() {
        students = value;
      });
    });
  }

  filterStudents() {
    List<String> filtered = [];
    filtered.addAll(students);
    if (search.text.isNotEmpty) {
      filtered.retainWhere((element) {
        return element.contains(search.text.toLowerCase());
      });
    }

    setState(() {
      filteredStudents = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllStudents();
    search.addListener(() {
      filterStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool searching = search.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Student"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: search,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD00001),
                  ),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Card(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searching == true
                    ? filteredStudents.length
                    : students.length,
                itemBuilder: (context, index) {
                  String name = searching == true
                      ? filteredStudents[index]
                      : students[index];
                  return ListTile(
                    title: Text(name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
