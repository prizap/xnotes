import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/local_database.dart';
import '../models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class NoteRepositoryImpl implements NoteRepository {
  final LocalDatabase dbHelper;

  NoteRepositoryImpl(this.dbHelper);

  @override
  Future<void> addNote(Note note) async {
    final db = await dbHelper.database;
    final model = NoteModel.fromEntity(note);
    await db.insert('notes', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteNote(String id) async {
    final db = await dbHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Note>> getNotes() async {
    final db = await dbHelper.database;
    final result = await db.query('notes', orderBy: 'created_at DESC');
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateNote(Note note) async {
    final db = await dbHelper.database;
    final model = NoteModel.fromEntity(note);
    await db.update('notes', model.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }
}
