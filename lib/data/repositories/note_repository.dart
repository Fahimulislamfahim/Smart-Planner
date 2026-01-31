import 'package:hive_flutter/hive_flutter.dart';
import '../local/hive_service.dart';
import '../models/note.dart';

class NoteRepository {
  Box<Note> get _box => Hive.box<Note>('notes');

  List<Note> getNotes() {
    return _box.values.toList();
  }

  Future<void> addNote(Note note) async {
    await _box.put(note.id, note);
  }

  Future<void> updateNote(Note note) async {
    await _box.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  Note? getNote(String id) {
    return _box.get(id);
  }

  Stream<BoxEvent> watchNotes() {
    return _box.watch();
  }
}
