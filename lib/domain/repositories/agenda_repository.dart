import '../entities/agenda.dart';

abstract class AgendaRepository {
  Future<void> addAgenda(Agenda agenda);
  Future<void> deleteAgenda(String id);
  Future<void> updateAgenda(Agenda agenda);
  Future<List<Agenda>> getAgendas();
}
