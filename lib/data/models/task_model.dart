import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? time; // Stored as String "HH:mm" for simplicity in storage

  @HiveField(5)
  final String priority; // Low, Medium, High

  @HiveField(6)
  final String category;

  @HiveField(7)
  bool isCompleted;

  @HiveField(8)
  bool hasReminder;

  @HiveField(9)
  bool isRecurring;

  @HiveField(10)
  int? reminderOffsetMinutes; // Minutes before task time, null = use default

  @HiveField(11)
  String? categoryId; // Link to Category

  @HiveField(12)
  List<String> subtaskIds; // List of subtask IDs

  Task({
    String? id,
    required this.title,
    this.description,
    required this.date,
    this.time,
    this.priority = 'Medium',
    this.category = 'General',
    this.isCompleted = false,
    this.hasReminder = false,
    this.isRecurring = false,
    this.reminderOffsetMinutes,
    this.categoryId,
    List<String>? subtaskIds,
  }) : id = id ?? const Uuid().v4(),
       subtaskIds = subtaskIds ?? [];

  factory Task.empty() {
    return Task(
      title: '',
      date: DateTime.now(),
    );
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? date,
    String? time,
    String? priority,
    String? category,
    bool? isCompleted,
    bool? hasReminder,
    bool? isRecurring,
    int? reminderOffsetMinutes,
    String? categoryId,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      hasReminder: hasReminder ?? this.hasReminder,
      isRecurring: isRecurring ?? this.isRecurring,
      reminderOffsetMinutes: reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
