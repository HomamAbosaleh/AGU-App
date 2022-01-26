import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../model/task.dart';

class Sqlite {
  static Future<sql.Database> _initDatabase() async {
    final sqlPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(sqlPath, 'localDatabase.db'),
        onCreate: (db, version) {
      return db
          .execute('''CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT,
          uid TEXT NOT NULL, 
        body TEXT NOT NULL,
        reminderIsSet TEXT NOT NULL)''');
    }, version: 1);
  }

  Future<List<Task>> getTasks() async {
    final db = await Sqlite._initDatabase();
    List<Map<String, dynamic>> listOFTasks =
        await db.query("tasks", where: 'uid = ?', whereArgs: [Constants.uid]);
    List<Task> tasks = [];

    for (var element in listOFTasks) {
      tasks.add(
        Task(
          id: element["id"],
          body: element["body"],
          reminderIsSet: element["reminderIsSet"] == "true" ? true : false,
        ),
      );
    }

    return tasks;
  }

  Future<int> insert(Task task) async {
    final db = await Sqlite._initDatabase();
    print(task.reminderIsSet);
    return await db.insert(
      'tasks',
      {
        "uid": Constants.uid,
        "body": task.body,
        "reminderIsSet": task.reminderIsSet.toString(),
      },
    );
  }

  Future<int> delete(int id) async {
    final db = await Sqlite._initDatabase();
    return await db.delete('tasks',
        where: 'id = ? AND uid = ?', whereArgs: [id, Constants.uid]);
  }

  Future<int> update(Task task) async {
    final db = await Sqlite._initDatabase();
    return await db.update(
        'tasks',
        {
          "uid": Constants.uid,
          "body": task.body,
          "reminderIsSet": task.reminderIsSet.toString(),
        },
        where: 'id = ? AND uid = ?',
        whereArgs: [task.id, Constants.uid]);
  }
}
