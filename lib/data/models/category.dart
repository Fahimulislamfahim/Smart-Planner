import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorValue; // Store as int for Hive

  @HiveField(3)
  String icon;

  Category({
    String? id,
    required this.name,
    required this.colorValue,
    this.icon = '📁',
  }) : id = id ?? const Uuid().v4();

  Color get color => Color(colorValue);

  set color(Color value) {
    colorValue = value.value;
  }

  Category copyWith({
    String? name,
    int? colorValue,
    String? icon,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      icon: icon ?? this.icon,
    );
  }

  // Default categories
  static List<Category> getDefaultCategories() {
    return [
      Category(
        name: 'Work',
        colorValue: Colors.blue.value,
        icon: '💼',
      ),
      Category(
        name: 'Personal',
        colorValue: Colors.green.value,
        icon: '🏠',
      ),
      Category(
        name: 'Health',
        colorValue: Colors.red.value,
        icon: '❤️',
      ),
      Category(
        name: 'Shopping',
        colorValue: Colors.orange.value,
        icon: '🛒',
      ),
      Category(
        name: 'Study',
        colorValue: Colors.purple.value,
        icon: '📚',
      ),
      Category(
        name: 'Finance',
        colorValue: Colors.teal.value,
        icon: '💰',
      ),
    ];
  }
}
