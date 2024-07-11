import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  static Database? _database;

  DBHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'city.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
      ''');
  }

  Future<int> creat(String name) async {
    final db = await database;
    return await db!.insert('cities', {'name': name});
  }

  Future<List<Map<String, dynamic>>> read() async {
    final db = await database;
    return await db!.query('cities');
  }

  Future<int> update(int id, String name) async {
    final db = await database;
    return await db!
        .update('cities', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db!.delete('cities', where: 'id = ?', whereArgs: [id]);
  }
}
