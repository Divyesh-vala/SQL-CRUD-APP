import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHandler {
  late Database database;
  createDB() async {
    print('*--------- createDB ---------*');
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // Check if the file exists
    bool isDatabaseExist = await File(path).exists();
    print("Database already exist");

    // open the database
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        if (!isDatabaseExist) {
          await db.execute(
            'CREATE TABLE Users (id INTEGER PRIMARY KEY, name TEXT, email TEXT, image TEXT)',
          );
        }
      },
    );
  }

  Future<int> insertDB({
    required String name,
    required String email,
    required String image,
  }) async {
    print(
      '*--------- insertDB ---------*\nName - $name\nEmail - $email\nImage - $image',
    );
    int id = 0;
    // Insert record in a transaction
    await database.transaction((txn) async {
      id = await txn.rawInsert(
        'INSERT INTO Users(name, email, image) VALUES("$name", "$email", "$image")',
      );
      print('inserted: $id');
    });
    return id;
  }

  Future<int> updateDB(
    int id, {
    required String name,
    required String email,
    required String image,
  }) async {
    // Update record
    int count = await database.rawUpdate(
      'UPDATE Users SET name = ?, email = ?, image = ? WHERE id = ?',
      [name, email, image, id],
    );
    print('updated: $count');
    return count;
  }

  Future<List<Map<String, dynamic>>> getDBdata() async {
    // Get the records
    List<Map<String, dynamic>> list = await database.rawQuery(
      'SELECT * FROM Users',
    );
    return list;
  }

  Future<int> deleteRecordOfDB(int id) async {
    // Delete a record
    int count = await database.rawDelete('DELETE FROM Users WHERE id = ?', [
      id,
    ]);
    print('deleted: $count');
    return count;
  }

  closeDB() async {
    // Close the database
    await database.close();
  }

  deleteDB(String path) async {
    // Delete the database
    await deleteDatabase(path);
  }
}

DbHandler dbHandler = DbHandler();
