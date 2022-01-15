import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class LocalDB extends StatefulWidget {
  const LocalDB({Key? key}) : super(key: key);

  @override
  State<LocalDB> createState() => _LocalDBState();
}

class _LocalDBState extends State<LocalDB> {
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
      body: Center(
        child: FutureBuilder<List<Grocery>>(
            future: DatabaseHelper.instance.getGrocories(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Grocery>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return snapshot.data!.isEmpty
                    ? Center(child: Text('Nothing added'))
                    : ListView(
                        children: snapshot.data!.map((grocery) {
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
                            DatabaseHelper.instance.remove(grocery.id!);

                            const snackBar = SnackBar(
                              content: Text('You just deleted the task'),
                              duration: Duration(milliseconds: 700),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: Card(
                            color: selectedID == grocery.id
                                ? Colors.grey[600]
                                : Colors.black87,
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  textController.text = grocery.name;
                                  selectedID = grocery.id;
                                });
                              },
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  grocery.name,
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
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        );
                      }).toList());
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedID != null) {
            if (formKey.currentState!.validate()) {
              await DatabaseHelper.instance
                  .update(Grocery(id: selectedID, name: textController.text));
            }
          } else if (formKey.currentState!.validate()) {
            await DatabaseHelper.instance.add(
              Grocery(name: textController.text),
            );
          }
          // selectedID != null
          //     ? await DatabaseHelper.instance
          //         .update(Grocery(id: selectedID, name: textController.text))
          //     : await DatabaseHelper.instance.add(
          //         Grocery(name: textController.text),
          //       );
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

class Grocery {
  final int? id;
  final String name;

  Grocery({
    this.id,
    required this.name,
  });

  factory Grocery.fromMap(Map<String, dynamic> json) => Grocery(
        id: json['id'],
        name: json['name'],
      );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  // DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabse();

  Future<Database> _initDatabse() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL 
      )
      ''');
  }

  Future<List<Grocery>> getGrocories() async {
    Database db = await instance.database;
    var grocories = await db.query('groceries', orderBy: 'name');
    List<Grocery> groceryList = grocories.isNotEmpty
        ? grocories.map((e) => Grocery.fromMap(e)).toList()
        : [];
    return groceryList;
  }

  Future<int> add(Grocery grocery) async {
    Database? db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(),
        where: 'id = ?', whereArgs: [grocery.id]);
  }
}
