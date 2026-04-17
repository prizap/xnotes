import '../entities/note.dart';
import '../repositories/note_repository.dart';

class AddNote {
  final NoteRepository repository;
  AddNote(this.repository);

  Future<void> call(Note note) {
    return repository.addNote(note);
  }
}

class GetNotes {
  final NoteRepository repository;
  GetNotes(this.repository);

  Future<List<Note>> call() {
    return repository.getNotes();
  }
}

class UpdateNote {
  final NoteRepository repository;
  UpdateNote(this.repository);

  Future<void> call(Note note) {
    return repository.updateNote(note);
  }
}

class DeleteNote {
  final NoteRepository repository;
  DeleteNote(this.repository);

  Future<void> call(String id) {
    return repository.deleteNote(id);
  }
}
