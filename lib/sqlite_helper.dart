import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  Future<void> dbCreate() async {
    late Database database;
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db'); //import path/path.dart

    // Delete the database
    await deleteDatabase(path);

    // open the database
    try {
      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE "vehicle_master" ("id" INTEGER,"name"	TEXT, "language" TEXT,PRIMARY KEY("id"))');
        await db.execute(
            'CREATE TABLE "vehicle_other" ("id"	INTEGER,"name"	TEXT,"language"	TEXT,"vehicle_master_id"	INTEGER,PRIMARY KEY("id"))');
      });
    } catch (e) {
      debugPrint(e.toString());
      debugPrint('エラー出た四');
    }

    // Insert some records in a transaction
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO vehicle_master(name, language) VALUES("truck", "en")');
      debugPrint('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO vehicle_master(name, language) VALUES("bicycle", "en")');
      debugPrint('inserted2: $id2');
      int id3 = await txn.rawInsert(
          'INSERT INTO vehicle_master(name, language) VALUES("train", "en")');
      debugPrint('inserted3: $id3');
    });

    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO vehicle_other(name, language,vehicle_master_id) VALUES("トラック", "ja",1)');
      debugPrint('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO vehicle_other(name, language,vehicle_master_id) VALUES("卡車", "zh-CN",1)');
      debugPrint('inserted2: $id2');
      int id3 = await txn.rawInsert(
          'INSERT INTO vehicle_other(name, language,vehicle_master_id) VALUES("自転車", "ja",2)');
      debugPrint('inserted3: $id3');
      int id4 = await txn.rawInsert(
          'INSERT INTO vehicle_other(name, language,vehicle_master_id) VALUES("自行車", "zh-CN",2)');
      debugPrint('inserted3: $id4');
      int id5 = await txn.rawInsert(
          'INSERT INTO vehicle_other(name, language,vehicle_master_id) VALUES("電車", "ja",3)');
      debugPrint('inserted3: $id5');
      int id6 = await txn.rawInsert(
          'INSERT INTO vehicle_other(name, language,vehicle_master_id) VALUES("火車", "zh-CN",3)');
      debugPrint('inserted3: $id6');
    });

    await database.close();
  }

  //get data from sqlite table
  Future<List<Map>> dataSelect(String locale) async {
    String sqlQuery;

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db'); //import path/path.dart
    Database database = await openDatabase(path);

    // Get the records
    if (locale == "en") {
      sqlQuery = 'SELECT * FROM vehicle_master';
    } else {
      sqlQuery = 'SELECT * FROM vehicle_other where language = "$locale"';
    }
    List<Map> list = await database.rawQuery(sqlQuery);

    await database.close();
    return list;
  }
}
