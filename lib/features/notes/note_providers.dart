import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/note_repository.dart';
import '../../data/models/note.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

final noteListProvider = StateNotifierProvider<NoteListNotifier, List<Note>>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return NoteListNotifier(repository);
});

class NoteListNotifier extends StateNotifier<List<Note>> {
  final NoteRepository _repository;

  NoteListNotifier(this._repository) : super([]) {
    loadNotes();
  }

  void loadNotes() {
    state = _repository.getNotes()
      ..sort((a, b) => b.dateModified.compareTo(a.dateModified)); // Sort by modified date desc
  }

  Future<void> addNote(Note note) async {
    await _repository.addNote(note);
    loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _repository.updateNote(note);
    loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
    loadNotes();
  }
}
