import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';
import '../services/sqllite.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksBState();
}

class _TasksBState extends State<Tasks> {
  int? selectedID;
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Form(
          key: formKey,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a non-empty task';
              }
              return null;
            },
            onSaved: (newValue) {
              textController.text = newValue!;
            },
            controller: textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Enter your task here',
              hintStyle: Theme.of(context).textTheme.caption,
              prefixIcon: Icon(
                Icons.text_snippet_outlined,
                color: Colors.grey[500],
              ),
            ),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Sqlite().getTasks(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.map<Widget>(
                  (task) {
                    return Dismissible(
                      key: UniqueKey(),
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              'Delete',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            content: const Text(
                              'are you sure?',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("Yes"))
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        Sqlite().delete(task.id!);
                        const snackBar = SnackBar(
                          content: Text('You just deleted the task'),
                          duration: Duration(milliseconds: 700),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Card(
                        color: selectedID == task.id
                            ? Colors.grey[600]
                            : Colors.black87,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              textController.text = task.body;
                              selectedID = task.id;
                            });
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              task.body,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          trailing: Text(
                            DateFormat.MMMMEEEEd()
                                .format(DateTime.now())
                                .toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            } else {
              return Center(
                child: Text(
                  'Nothing added',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedID != null) {
            if (formKey.currentState!.validate()) {
              await Sqlite()
                  .update(Task(id: selectedID!, body: textController.text));
            }
          } else if (formKey.currentState!.validate()) {
            await Sqlite().insert(
              Task(body: textController.text),
            );
          }
          setState(() {
            textController.clear();
            selectedID = null;
          });
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}
