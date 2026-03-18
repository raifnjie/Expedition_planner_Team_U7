// This class provides a centralized SQLite database helper for the Expedition Planner app.
// It handles creating the database and tables, and provides CRUD operations for 
// expeditions and related data (routes, gear, logs, expenses, tasks).

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expedition.dart';

class DatabaseHelper {
  //Singleton instance to ensure the only one database connection exists 
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();
//Getter for the database, initializes it if it doesn't exist yet
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expedition_planner.db');
    return _database!;
  }
//initialize databse and create tables if they don't exist already
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

//create all necessary tables for the app
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
//create new expidition record
  Future<int> createExpedition(Expedition expedition) async {
    final db = await instance.database;
    return await db.insert('expeditions', expedition.toMap());
  }

//Get all expiditions, newest first
  Future<List<Expedition>> getAllExpeditions() async {
    final db = await instance.database;
    final result = await db.query(
      'expeditions',
      orderBy: 'id DESC',
    );

    return result.map((map) => Expedition.fromMap(map)).toList();
  }

//Get a single expidition by ID 
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

//Update an exisiting expidition
  Future<int> updateExpedition(Expedition expedition) async {
    final db = await instance.database;
    return await db.update(
      'expeditions',
      expedition.toMap(),
      where: 'id = ?',
      whereArgs: [expedition.id],
    );
  }

//Delete an expidition and all related data
  Future<int> deleteExpedition(int id) async {
    final db = await instance.database;
//Delete related records first
    await db.delete('routes', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('gear', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('logs', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('expenses', where: 'expeditionId = ?', whereArgs: [id]);
    await db.delete('tasks', where: 'expeditionId = ?', whereArgs: [id]);

//Expidition deletion itself
    return await db.delete(
      'expeditions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
//databse connection close method
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}