import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'equations.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE equations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        a REAL NOT NULL,
        b REAL NOT NULL,
        c REAL NOT NULL,
        discriminant REAL NOT NULL,
        result TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  /// Добавление записи
  Future<int> insertEquation(Map<String, dynamic> row) async {
    final db = await database;
    return db.insert('equations', row);
  }

  /// Все записи (сортировка по дате — новые сверху)
  Future<List<Map<String, dynamic>>> getAllEquations() async {
    final db = await database;
    return db.query('equations', orderBy: 'created_at DESC');
  }

  /// Одна запись по id
  Future<Map<String, dynamic>?> getEquation(int id) async {
    final db = await database;
    final rows = await db.query(
      'equations',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  /// Удаление по id
  Future<int> deleteEquation(int id) async {
    final db = await database;
    return db.delete('equations', where: 'id = ?', whereArgs: [id]);
  }

  /// Удалить всю историю
  Future<int> deleteAll() async {
    final db = await database;
    return db.delete('equations');
  }
}