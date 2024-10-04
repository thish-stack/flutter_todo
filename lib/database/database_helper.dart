import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:producthive/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    print('db init');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
  String path = join(await getDatabasesPath(), 'tasks.db');
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
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

Future<List<Task>> getTasks() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('tasks');
  return List.generate(maps.length, (i) {
    return Task(
      id: maps[i]['id'],
      name: maps[i]['name'],
      completed: maps[i]['completed'] == 1,
      date: DateTime.parse(maps[i]['date']),
    );
  });
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
}
