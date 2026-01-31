import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/focus_session.dart';

final focusSessionProvider = StateNotifierProvider<FocusSessionNotifier, List<FocusSession>>((ref) {
  return FocusSessionNotifier();
});

class FocusSessionNotifier extends StateNotifier<List<FocusSession>> {
  static const String _boxName = 'focus_sessions';

  FocusSessionNotifier() : super([]) {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final box = await Hive.openBox<FocusSession>(_boxName);
    state = box.values.toList();
  }

  Future<void> addSession(int durationMinutes, String type) async {
    final session = FocusSession(
      id: const Uuid().v4(),
      date: DateTime.now(),
      durationMinutes: durationMinutes,
      type: type,
    );

    final box = await Hive.openBox<FocusSession>(_boxName);
    await box.put(session.id, session);
    state = [...state, session];
  }

  int getTotalFocusMinutes() {
    return state
        .where((session) => session.type == 'work')
        .fold(0, (sum, session) => sum + session.durationMinutes);
  }

  int getTodayFocusMinutes() {
    final today = DateTime.now();
    return state
        .where((session) =>
            session.type == 'work' &&
            session.date.year == today.year &&
            session.date.month == today.month &&
            session.date.day == today.day)
        .fold(0, (sum, session) => sum + session.durationMinutes);
  }
}
