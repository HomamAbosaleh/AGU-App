import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/appbar.dart';
import '../services/firestore.dart';
import 'conversation.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchBarText = TextEditingController();
  QuerySnapshot? searchSnapShot;

  createChatRoom(String userName) async {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
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

  void search() {
    FireStore().getUser(searchBarText.text).then((value) {
      setState(() {
        searchSnapShot = value;
      });
    });
  }

  Widget searchTile({required String name, required String email}) {
    return InkWell(
      onTap: () {
        createChatRoom(name);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              textAlign: TextAlign.left,
            ),
            Text(
              email,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapShot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapShot!.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                  name: searchSnapShot!.docs[index].get("name"),
                  email: searchSnapShot!.docs[index].get("email"));
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Column(
        children: [
          Card(
            elevation: 6,
            child: TextField(
              controller: searchBarText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                suffixIcon: IconButton(
                    onPressed: () {
                      search();
                    },
                    icon: const Icon(Icons.search)),
                labelText: "search name surname",
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD00001))),
              ),
            ),
          ),
          searchList(),
        ],
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
