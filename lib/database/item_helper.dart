import 'package:flutter_anuncios/database/database_helper.dart';
import 'package:flutter_anuncios/model/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemHelper {
  static final String tableName = "tasks";
  static final String idColumn = "id";
  static final String nameColumn = "name";
  static final String descriptionColumn = "description";
  static final String valueColumn = "value";
  static final String doneColumn = "done";
  static final String imagePathColumn = "imagePath";

  static String get createScript {
    return "CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY AUTOINCREMENT," +
        "$nameColumn TEXT NOT NULL, $descriptionColumn TEXT NOT NULL, " +
        "$valueColumn TEXT NOT NULL, $doneColumn INTEGER NOT NULL, $imagePathColumn STRING);";
  }

  Future<List<Item>> getAll() async {
    Database? db = await DatabaseHelper().db;
    List<Item> items = List.empty(growable: true);
    if (db == null) return items;

    List<Map> returnedTasks = await db.query(tableName, columns: [
      idColumn,
      nameColumn,
      descriptionColumn,
      valueColumn,
      doneColumn,
      imagePathColumn
    ]);

    for (Map item in returnedTasks) {
      items.add(Item.fromMap(item));
    }
    return items;
  }

  Future<Item?> getById(int id) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    List<Map> returnedTask = await db.query(tableName,
        columns: [
          idColumn,
          nameColumn,
          descriptionColumn,
          valueColumn,
          doneColumn,
          doneColumn,
          imagePathColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);

    return Item.fromMap(returnedTask.first);
  }

  Future<Item?> saveItem(Item item) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      int id = await db.insert(tableName, item.toMap());
      return item;
    }
    return null;
  }

  Future<Item?> updateItem(Item item) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      db.update(tableName, item.toMap(),
          where: "$idColumn=?", whereArgs: [item.id]);
      return item;
    }
    return null;
  }

  Future<int?> deleteItem(Item item) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;
    return await db
        .delete(tableName, where: "$idColumn = ?", whereArgs: [item.id]);
  }
}
