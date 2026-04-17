enum MediaType { none, text, image, video, audio }

class Note {
  final String id;
  final String title;
  final String textContent;
  final String? mediaPath;
  final MediaType mediaType;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.textContent,
    this.mediaPath,
    required this.mediaType,
    required this.createdAt,
  });
}
