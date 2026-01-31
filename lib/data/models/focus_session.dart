import 'package:hive/hive.dart';

part 'focus_session.g.dart';

@HiveType(typeId: 5)
class FocusSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int durationMinutes;

  @HiveField(3)
  final String type; // 'work' or 'break'

  FocusSession({
    required this.id,
    required this.date,
    required this.durationMinutes,
    required this.type,
  });
}
