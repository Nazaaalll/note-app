import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class queryHelper {
  //table creation
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
CREATE TABLE note(
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
title TEXT,
description TEXT,
time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)
""");
  }

  //ends here
  //create a database
  static Future<sql.Database> db() async {
    return sql.openDatabase("note_database.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  //ends
  //insert a new note into a table
  static Future<int> createNote(String title, String? description) async {
    final db = await queryHelper.db();
    final dataNote = {
      'title': title,
      'Description': description,
    };
    final id = await db.insert('note', dataNote,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //ends
  //get all notes
  static Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await queryHelper.db();
    return db.query('note', orderBy: 'id');
  }

  //end
//get a single note
  static Future<List<Map<String,dynamic>>> getNote(int id) async {
    final db = await queryHelper.db();
    return db.query('note', where: "id = ?", whereArgs: [id], limit: 1);
  }

//ends
//update
  static Future<int> updateNote(
    int id,
    String title,
    String? description,
  ) async {
    final db = await queryHelper.db();
    final dataNote = {
      'title': title,
      'descrition': description,
      'time': DateTime.now().toString()
    };
    final result =
        await db.update('note', dataNote, where: "id = ?", whereArgs: [id]);
    return result;
  }
//end
//delet a note

  static Future<void> deletNote(int id) async {
    final db = await queryHelper.db();
    try {
      await db.delete('note', where: "id = ?", whereArgs: [id]);
    } catch (e) {
      e.toString();
    }
  }

//end
//delet all notes
  static Future<void> deletAllNotes() async {
    final db = await queryHelper.db();
    try {
      await db.delete('note');
    } catch (e) {
      print(e.toString());
    }
  }

//ends
//counts
  static Future<int> getNoteCount() async {
    final db = await queryHelper.db();
    try {
      final cound = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT (*) FROME note'));
      return cound ?? 0;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
//end
}
