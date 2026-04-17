import '../../domain/entities/agenda.dart';
import '../../domain/repositories/agenda_repository.dart';
import '../datasources/local_database.dart';
import '../models/agenda_model.dart';
import 'package:sqflite/sqflite.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  final LocalDatabase dbHelper;

  AgendaRepositoryImpl(this.dbHelper);

  @override
  Future<void> addAgenda(Agenda agenda) async {
    final db = await dbHelper.database;
    final model = AgendaModel.fromEntity(agenda);
    await db.insert('agendas', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteAgenda(String id) async {
    final db = await dbHelper.database;
    await db.delete('agendas', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Agenda>> getAgendas() async {
    final db = await dbHelper.database;
    final result = await db.query('agendas', orderBy: 'date_time ASC');
    return result.map((map) => AgendaModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateAgenda(Agenda agenda) async {
    final db = await dbHelper.database;
    final model = AgendaModel.fromEntity(agenda);
    await db.update('agendas', model.toMap(),
        where: 'id = ?', whereArgs: [agenda.id]);
  }
}
