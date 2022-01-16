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
        body TEXT NOT NULL)''');
    }, version: 1);
  }

  Future<List<Task>> getTasks() async {
    final db = await Sqlite._initDatabase();
    var listOFTasks =
        await db.query("tasks", where: 'uid = ?', whereArgs: [Constants.uid]);
    List<Task> tasks = listOFTasks.isNotEmpty
        ? listOFTasks.map<Task>((e) => Task.fromMap(e)).toList()
        : [];
    return tasks;
  }

  Future<int> insert(Task task) async {
    final db = await Sqlite._initDatabase();
    return await db.insert(
      'tasks',
      {
        "uid": Constants.uid,
        "body": task.body,
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
        },
        where: 'id = ? AND uid = ?',
        whereArgs: [task.id, Constants.uid]);
  }
}
