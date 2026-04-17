import 'package:flutter/material.dart';
import '../../domain/entities/agenda.dart';
import '../../domain/usecases/agenda_usecases.dart';

class AgendaProvider with ChangeNotifier {
  final GetAgendas getAgendasUseCase;
  final AddAgenda addAgendaUseCase;
  final UpdateAgenda updateAgendaUseCase;
  final DeleteAgenda deleteAgendaUseCase;

  List<Agenda> _agendas = [];
  List<Agenda> get agendas => _agendas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AgendaProvider({
    required this.getAgendasUseCase,
    required this.addAgendaUseCase,
    required this.updateAgendaUseCase,
    required this.deleteAgendaUseCase,
  }) {
    fetchAgendas();
  }

  Future<void> fetchAgendas() async {
    _isLoading = true;
    notifyListeners();

    _agendas = await getAgendasUseCase.call();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAgendaAndRefresh(Agenda agenda) async {
    await addAgendaUseCase.call(agenda);
    await fetchAgendas();
  }

  Future<void> updateAgendaAndRefresh(Agenda agenda) async {
    await updateAgendaUseCase.call(agenda);
    await fetchAgendas();
  }

  Future<void> deleteAgendaAndRefresh(Agenda agenda) async {
    await deleteAgendaUseCase.call(agenda);
    await fetchAgendas();
  }
}
