import '../entities/agenda.dart';
import '../repositories/agenda_repository.dart';
import '../../core/services/notification_service.dart';

class AddAgenda {
  final AgendaRepository repository;
  final NotificationService notificationService;

  AddAgenda(this.repository, this.notificationService);

  Future<void> call(Agenda agenda) async {
    await repository.addAgenda(agenda);
    await notificationService.scheduleAgendaNotification(agenda);
  }
}

class GetAgendas {
  final AgendaRepository repository;

  GetAgendas(this.repository);

  Future<List<Agenda>> call() {
    return repository.getAgendas();
  }
}

class TriggerReminder {
  final NotificationService notificationService;

  TriggerReminder(this.notificationService);

  Future<void> call(Agenda agenda) async {
    await notificationService.scheduleAgendaNotification(agenda);
  }
}

class UpdateAgenda {
  final AgendaRepository repository;
  final NotificationService notificationService;

  UpdateAgenda(this.repository, this.notificationService);

  Future<void> call(Agenda agenda) async {
    await repository.updateAgenda(agenda);
    await notificationService.scheduleAgendaNotification(agenda);
  }
}

class DeleteAgenda {
  final AgendaRepository repository;
  final NotificationService notificationService;

  DeleteAgenda(this.repository, this.notificationService);

  Future<void> call(Agenda agenda) async {
    await repository.deleteAgenda(agenda.id);
    await notificationService.cancelNotification(agenda.reminderId);
  }
}
