import 'package:final_project/widgets/drawer.dart';
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
  final ScrollController _scroller = ScrollController();

  String getName() {
    return widget.chatRoomId.split(" ")[0].substring(0, 1).toUpperCase() +
        widget.chatRoomId.split(" ")[0].substring(1) +
        " " +
        widget.chatRoomId.split(" ")[1].substring(0, 1).toUpperCase() +
        widget.chatRoomId.split(" ")[1].substring(1);
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

  setPostion() async {
    _scroller.animateTo(_scroller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            drawer: customDrawer(context),
            appBar: AppBar(
              title: Text(getName()),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/navigationBar", (route) => false);
                },
              ),
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scroller,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.docs.length) {
                          return const SizedBox(
                            height: 20,
                          );
                        } else {
                          return MessageTile(
                            message: snapshot.data.docs[index]["message"],
                            isSendByMe: snapshot.data.docs[index]["sendBy"] ==
                                Constants.myName,
                          );
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      elevation: 6,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        scrollPadding: const EdgeInsets.only(top: 20),
                        controller: message,
                        onTap: () {
                          setPostion();
                        },
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setPostion();
                                sendMessage();
                              },
                              icon: const Icon(Icons.send)),
                          labelText: "Message ...",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
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
