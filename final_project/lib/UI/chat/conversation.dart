import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../services/firestore.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  const Conversation({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController message = TextEditingController();
  Stream? chatMessagesStream;

  String getName() {
    return widget.chatRoomId.split(" ")[0].substring(0, 1).toUpperCase() +
        widget.chatRoomId.split(" ")[0].substring(1) +
        " " +
        widget.chatRoomId.split(" ")[1].substring(0, 1).toUpperCase() +
        widget.chatRoomId.split(" ")[1].substring(1);
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.docs[index]["message"],
                isSendByMe:
                    snapshot.data.docs[index]["sendBy"] == Constants.myName,
              );
            },
          );
        }
      },
    );
  }

  sendMessage() {
    if (message.text.isNotEmpty) {
      List<String> users = [widget.chatRoomId, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": widget.chatRoomId,
      };
      Map<String, dynamic> sendToChatRoomMap = {
        "users": users,
        "chatRoomId": Constants.myName,
      };
      FireStore()
          .createChatRoom(widget.chatRoomId, chatRoomMap, sendToChatRoomMap);
      Map<String, dynamic> messageMap = {
        "message": message.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      FireStore().addConversationMessages(widget.chatRoomId, messageMap);
      message.text = "";
    }
  }

  @override
  void initState() {
    FireStore().getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getName()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/chat", (route) => false);
          },
        ),
      ),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 6,
              child: TextField(
                controller: message,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  suffixIcon: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(Icons.send)),
                  labelText: "Message ...",
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD00001))),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD00001))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({Key? key, required this.message, required this.isSendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC),
                      ]
                    : [
                        const Color(0x1AFFFFFF),
                        const Color(0x1AFFFFFF),
                      ]),
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
