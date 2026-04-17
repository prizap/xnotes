import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required super.id,
    required super.title,
    required super.textContent,
    super.mediaPath,
    required super.mediaType,
    required super.createdAt,
  });

  factory NoteModel.fromEntity(Note entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      textContent: entity.textContent,
      mediaPath: entity.mediaPath,
      mediaType: entity.mediaType,
      createdAt: entity.createdAt,
    );
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      textContent: map['text_content'],
      mediaPath: map['media_path'],
      mediaType: MediaType.values.firstWhere(
        (e) => e.toString() == map['media_type'],
        orElse: () => MediaType.none,
      ),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text_content': textContent,
      'media_path': mediaPath,
      'media_type': mediaType.toString(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
