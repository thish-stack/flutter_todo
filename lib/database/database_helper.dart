import 'package:path/path.dart';
import 'package:producthive/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

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
    String path = join(await getDatabasesPath(), 'tasks.db');
    print("Database Path: $path");
    print('db opened');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        print("db created");
        return db.execute(
          '''CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, completed INTEGER, date TEXT)''',
        );
      },
    );
  }

  Future<void> addTask(Task task) async {
    print('db add task called');
    print('db get tasks: ${getTasks()} are');
    final db = await database;
   try {
  await db.insert(
    'tasks',
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
} catch (e) {
  print("Error inserting task: $e");
}
  }

 Future<List<Task>> getTasks() async {
 
  final db = await database;
  List<Map<String, dynamic>> results = await db.query( "tasks",);

  // Create a list to hold the Task objects
  List<Task> tasks = [];
  // Loop through the results and convert each map to a Task object
  for (var result in results) {
    Task task = Task.fromMap(result); 
    tasks.add(task); 
  }
  // Return the list of Task objects
  return tasks;
}

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete('tasks');
  }
}
