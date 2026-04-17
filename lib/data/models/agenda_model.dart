import '../../domain/entities/agenda.dart';

class AgendaModel extends Agenda {
  AgendaModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dateTime,
    super.isCompleted,
    required super.reminderId,
  });

  factory AgendaModel.fromEntity(Agenda entity) {
    return AgendaModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dateTime: entity.dateTime,
      isCompleted: entity.isCompleted,
      reminderId: entity.reminderId,
    );
  }

  factory AgendaModel.fromMap(Map<String, dynamic> map) {
    return AgendaModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['date_time']),
      isCompleted: map['is_completed'] == 1,
      reminderId: map['reminder_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_time': dateTime.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'reminder_id': reminderId,
    };
  }
}
