import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/widgets/drawer.dart';
import '../../services/firestore.dart';
import 'conversation.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return ChatRoomTile(
                userName: snapshot.data.docs[index]["chatRoomId"],
                snapshot: snapshot.data.docs[index],
              );
            },
          );
        }
      },
    );
  }

  getUserInfo() async {
    await FireStore().getChatRooms().then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: customDrawer(context),
      appBar: AppBar(
        title: const Text("Chat Rooms"),
        centerTitle: true,
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.pushNamed(context, "/search");
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final DocumentSnapshot snapshot;
  const ChatRoomTile({
    Key? key,
    required this.userName,
    required this.snapshot,
  }) : super(key: key);

  String getName() {
    return userName.split(" ")[0].substring(0, 1).toUpperCase() +
        userName.split(" ")[0].substring(1) +
        " " +
        userName.split(" ")[1].substring(0, 1).toUpperCase() +
        userName.split(" ")[1].substring(1);
  }

  String getAbbreviation() {
    return userName.split(" ")[0].substring(0, 1).toUpperCase() +
        userName.split(" ")[1].substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    bool? answer;
    return Dismissible(
      key: ValueKey(userName),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.black,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            title: const Text("Verification"),
            content: Text("Do you want to delete your chat with ${getName()}?"),
            actions: [
              TextButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(ctx).pop(false); // dismiss dialog
                },
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.of(ctx).pop(true); // dismiss dialog
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        FireStore().deleteChatRoom(snapshot);
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Conversation(chatRoomId: userName),
            ),
          );
        },
        child: Container(
          color: Colors.black26,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40)),
                child: Text(getAbbreviation()),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(getName()),
            ],
          ),
        ),
      ),
    );
  }
}
