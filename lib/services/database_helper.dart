import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expedition.dart';
import '../models/route_item.dart';
import '../models/gear_item.dart';
import '../models/trail_log_item.dart';
import '../models/expense_item.dart';
import '../models/task_item.dart';

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
    final result = await db.query('expeditions', orderBy: 'id DESC');
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

  Future<int> createRoute(RouteItem route) async {
    final db = await instance.database;
    return await db.insert('routes', route.toMap());
  }

  Future<List<RouteItem>> getRoutesForExpedition(int expeditionId) async {
    final db = await instance.database;
    final result = await db.query(
      'routes',
      where: 'expeditionId = ?',
      whereArgs: [expeditionId],
      orderBy: 'id DESC',
    );
    return result.map((map) => RouteItem.fromMap(map)).toList();
  }

  Future<int> updateRoute(RouteItem route) async {
    final db = await instance.database;
    return await db.update(
      'routes',
      route.toMap(),
      where: 'id = ?',
      whereArgs: [route.id],
    );
  }

  Future<int> deleteRoute(int id) async {
    final db = await instance.database;
    return await db.delete('routes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createGearItem(GearItem item) async {
    final db = await instance.database;
    return await db.insert('gear', item.toMap());
  }

  Future<List<GearItem>> getGearForExpedition(int expeditionId) async {
    final db = await instance.database;
    final result = await db.query(
      'gear',
      where: 'expeditionId = ?',
      whereArgs: [expeditionId],
      orderBy: 'id DESC',
    );
    return result.map((map) => GearItem.fromMap(map)).toList();
  }

  Future<int> updateGearItem(GearItem item) async {
    final db = await instance.database;
    return await db.update(
      'gear',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteGearItem(int id) async {
    final db = await instance.database;
    return await db.delete('gear', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createTrailLog(TrailLogItem log) async {
    final db = await instance.database;
    return await db.insert('logs', log.toMap());
  }

  Future<List<TrailLogItem>> getLogsForExpedition(int expeditionId) async {
    final db = await instance.database;
    final result = await db.query(
      'logs',
      where: 'expeditionId = ?',
      whereArgs: [expeditionId],
      orderBy: 'id DESC',
    );
    return result.map((map) => TrailLogItem.fromMap(map)).toList();
  }

  Future<int> updateTrailLog(TrailLogItem log) async {
    final db = await instance.database;
    return await db.update(
      'logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> deleteTrailLog(int id) async {
    final db = await instance.database;
    return await db.delete('logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createExpense(ExpenseItem expense) async {
    final db = await instance.database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<ExpenseItem>> getExpensesForExpedition(int expeditionId) async {
    final db = await instance.database;
    final result = await db.query(
      'expenses',
      where: 'expeditionId = ?',
      whereArgs: [expeditionId],
      orderBy: 'id DESC',
    );
    return result.map((map) => ExpenseItem.fromMap(map)).toList();
  }

  Future<int> updateExpense(ExpenseItem expense) async {
    final db = await instance.database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await instance.database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createTask(TaskItem task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<TaskItem>> getTasksForExpedition(int expeditionId) async {
    final db = await instance.database;
    final result = await db.query(
      'tasks',
      where: 'expeditionId = ?',
      whereArgs: [expeditionId],
      orderBy: 'id DESC',
    );
    return result.map((map) => TaskItem.fromMap(map)).toList();
  }

  Future<int> updateTask(TaskItem task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotalRouteDistance(int expeditionId) async {
    final routes = await getRoutesForExpedition(expeditionId);
    double total = 0;
    for (final route in routes) {
      total += double.tryParse(route.distance) ?? 0;
    }
    return total;
  }

  Future<double> getTotalGearWeight(int expeditionId) async {
    final gear = await getGearForExpedition(expeditionId);
    double total = 0;
    for (final item in gear) {
      total += double.tryParse(item.weight) ?? 0;
    }
    return total;
  }

  Future<double> getTotalExpenses(int expeditionId) async {
    final expenses = await getExpensesForExpedition(expeditionId);
    double total = 0;
    for (final expense in expenses) {
      total += double.tryParse(expense.amount) ?? 0;
    }
    return total;
  }

  Future<Map<String, int>> getTaskStats(int expeditionId) async {
    final tasks = await getTasksForExpedition(expeditionId);
    final completed = tasks.where((task) => task.isCompleted).length;
    return {
      'completed': completed,
      'total': tasks.length,
    };
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}