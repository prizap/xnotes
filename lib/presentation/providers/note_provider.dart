import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/note_usecases.dart';

class NoteProvider with ChangeNotifier {
  final GetNotes getNotesUseCase;
  final AddNote addNoteUseCase;
  final UpdateNote updateNoteUseCase;
  final DeleteNote deleteNoteUseCase;

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NoteProvider({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) {
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();

    _notes = await getNotesUseCase.call();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNoteAndRefresh(Note note) async {
    await addNoteUseCase.call(note);
    await fetchNotes();
  }

  Future<void> updateNoteAndRefresh(Note note) async {
    await updateNoteUseCase.call(note);
    await fetchNotes();
  }

  Future<void> deleteNoteAndRefresh(String id) async {
    await deleteNoteUseCase.call(id);
    await fetchNotes();
  }
}
