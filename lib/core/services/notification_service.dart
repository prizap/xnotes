import '../../domain/entities/agenda.dart';

abstract class NotificationService {
  Future<void> init();
  Future<void> scheduleAgendaNotification(Agenda agenda);
  Future<void> cancelNotification(int id);
}
