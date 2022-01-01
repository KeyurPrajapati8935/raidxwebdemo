import 'dart:developer';

import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT,
        password TEXT,
        designation TEXT,
        company TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'practical.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String name, String? email, String? password,
      String? designation, String? company) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'designation': designation,
      'company': company,
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'designation': title,
      'company': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> forGotPassword(String email, String? password) async {

    final db = await SQLHelper.db();
    final data = {
      'email': email,
      'password': password,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "password = ?", whereArgs: [password]);
    return result;
  }


}
