import 'package:notes/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteProvider {
  static const databaseName = 'notes.db';
  static const notesTableName = 'Notes';

  static Database database;

  static Future open() async {
    database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (Database db, int version) async {
        db.execute('''
        CREATE TABLE Notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          colors TEXT
        );
        ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getNoteList() async {
    if (database == null) {
      await open();
    }

    return await database.query(notesTableName);
  }

  static Future insertNote(Note note) async {
    await database.insert(notesTableName, note.toMap());
  }

  static Future updateNote(Note note) async {
    await database.update(
      notesTableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future deleteNote(int id) async {
    await database.delete(notesTableName, where: 'id = ?', whereArgs: [id]);
  }
}
