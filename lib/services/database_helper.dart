import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expedition.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expedition_planner.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expeditions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        notes TEXT,
        riskLevel TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE routes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expeditionId INTEGER NOT NULL,
        routeName TEXT,
        distance TEXT,
        riskLevel TEXT,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE gear (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expeditionId INTEGER NOT NULL,
        itemName TEXT,
        category TEXT,
        weight TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expeditionId INTEGER NOT NULL,
        note TEXT,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expeditionId INTEGER NOT NULL,
        title TEXT,
        amount TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expeditionId INTEGER NOT NULL,
        title TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> createExpedition(Expedition expedition) async {
    final db = await instance.database;
    return await db.insert('expeditions', expedition.toMap());
  }

  Future<List<Expedition>> getAllExpeditions() async {
    final db = await instance.database;
    final result = await db.query(
      'expeditions',
      orderBy: 'id DESC',
    );

    return result.map((map) => Expedition.fromMap(map)).toList();
  }

  Future<Expedition?> getExpeditionById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'expeditions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return Expedition.fromMap(result.first);
  }

  Future<int> updateExpedition(Expedition expedition) async {
    final db = await instance.database;
    return await db.update(
      'expeditions',
      expedition.toMap(),
      where: 'id = ?',
      whereArgs: [expedition.id],
    );
  }

  Future<int> deleteExpedition(int id) async {
    final db = await instance.database;

    await db.delete('routes', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('gear', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('logs', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('expenses', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('tasks', where: 'expeditionId = ?', whereArgs: [id]);

    return await db.delete(
      'expeditions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}