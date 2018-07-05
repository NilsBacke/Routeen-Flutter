import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:routeen/data/task.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "tasksTable";
final String columnId = "id";
final String columnName = "name";
final String columnIsCompleted = "isCompleted";

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnIsCompleted INTEGER)");
  }

  Future<int> insert(Task task) async {
    var _db = await db;
    int res = await _db.insert(tableName, task.toMap());
    return res;
  }

  Future<Task> getTask(int id) async {
    var _db = await db;
    var maps = await _db.query(tableName,
        columns: [columnId, columnName, columnIsCompleted],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Task.fromMap(maps.first);
    }
    return null;
  }

  Future<List> getAllTasks() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName");

    return result.toList();
  }

  Future<int> deleteTask(String name) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableName, where: "$columnName = ?", whereArgs: [name]);
  }

  Future<int> updateTask(Task task) async {
    deleteTask(task.name);
    return insert(task);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
