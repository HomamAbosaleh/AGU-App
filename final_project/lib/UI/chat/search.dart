import 'package:flutter/material.dart';

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

  String getName(name) {
    return name.split(" ")[0].substring(0, 1).toUpperCase() +
        name.split(" ")[0].substring(1) +
        " " +
        name.split(" ")[1].substring(0, 1).toUpperCase() +
        name.split(" ")[1].substring(1);
  }

  createChatRoom(name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Conversation(
          chatRoomId: name,
        ),
      ),
    );
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
          automaticallyImplyLeading: false,
          title: const Text("Search Student"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )),
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
                  return InkWell(
                    onTap: () {
                      createChatRoom(name);
                    },
                    child: ListTile(
                      title: Text(getName(name)),
                    ),
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
