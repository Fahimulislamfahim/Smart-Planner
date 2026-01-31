import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@HiveType(typeId: 6)
class Note extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  int colorValue;

  @HiveField(4)
  final DateTime dateCreated;

  @HiveField(5)
  DateTime dateModified;

  Note({
    String? id,
    required this.title,
    required this.content,
    required this.colorValue,
    required this.dateCreated,
    required this.dateModified,
  }) : id = id ?? const Uuid().v4();

  Color get color => Color(colorValue);

  set color(Color value) {
    colorValue = value.value;
  }

  Note copyWith({
    String? title,
    String? content,
    int? colorValue,
    DateTime? dateModified,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      colorValue: colorValue ?? this.colorValue,
      dateCreated: dateCreated,
      dateModified: dateModified ?? this.dateModified,
    );
  }
}
