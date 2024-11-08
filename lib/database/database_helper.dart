// database_helper.dart

import 'package:path/path.dart';
import 'package:producthive/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'database_constants.dart';
import 'database_queries.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    print('db init');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path =
        join(await getDatabasesPath(), DatabaseConstants.databaseName);
    print("Database Path: $path");
    print('db opened');

    return await openDatabase(
      path,
      version: DatabaseQueries.migrations.length +
          1, // Version based on migration count
      onCreate: (Database db, int version) async {
        for (var script in DatabaseQueries.initialScript) {
          await db.execute(script);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print('onUpgrade called from $oldVersion to $newVersion');
        for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
          await db.execute(DatabaseQueries.migrations[i]);
        }
      },
    );
  }

  Future<void> addTask(Task task) async {
    print('db add task called');
    print('db get tasks: ${getTasks()} are');
    final db = await database;
    try {
      await db.insert(
        DatabaseConstants.tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting task: $e");
    }
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseConstants.tableName);

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i][DatabaseConstants.columnId],
        name: maps[i][DatabaseConstants.columnName],
        completed: maps[i][DatabaseConstants.columnCompleted] == 1,
        date: DateTime.parse(maps[i][DatabaseConstants.columnDate]),
        description: maps[i][DatabaseConstants.columnDescription], 
        apiId: maps[i][DatabaseConstants.columnApiId],
      );
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      DatabaseConstants.tableName,
      task.toMap(),
      where: '${DatabaseConstants.columnApiId} = ?',
      whereArgs: [task.apiId],
    );
  }

  Future<void> deleteTask(String apiId) async {
    final db = await database;
    await db.delete(
      DatabaseConstants.tableName,
      where: '${DatabaseConstants.columnApiId} = ?',
      whereArgs: [apiId],
    );
  }

  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete(DatabaseConstants.tableName);
  }
}
