import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            isChecked INTEGER
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await database;
    return await db.query('todos');
  }

  Future<void> insertTodo(Map<String, dynamic> todo) async {
    final db = await database;
    await db.insert('todos', todo);
  }

  Future<void> updateTodo(Map<String, dynamic> todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo,
      where: 'id = ?',
      whereArgs: [todo['id']],
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
