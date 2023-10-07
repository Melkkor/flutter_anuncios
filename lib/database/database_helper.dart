import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_anuncios/database/item_helper.dart';

class DatabaseHelper {
  Database? _db;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  Future<Database?> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'taskDatabase.db');

    try {
      return _db = await openDatabase(path,
          version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    } catch (e) {
      print(e);
    }
  }

  Future _onCreate(Database db, int newVersion) async {
    await db.execute(ItemHelper.createScript);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE ${ItemHelper.tableName};");
      await _onCreate(db, newVersion);
    }
  }
}
