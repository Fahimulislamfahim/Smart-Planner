import 'package:hive_flutter/hive_flutter.dart';
import '../local/hive_service.dart';
import '../models/category.dart';

class CategoryRepository {
  Box<Category> get _box => HiveService.getCategoryBox();

  List<Category> getCategories() {
    final categories = _box.values.toList();
    
    // If no categories exist, create defaults
    if (categories.isEmpty) {
      final defaults = Category.getDefaultCategories();
      for (var category in defaults) {
        _box.put(category.id, category);
      }
      return defaults;
    }
    
    return categories;
  }

  Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
  }

  Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }

  Category? getCategoryById(String id) {
    return _box.get(id);
  }

  Stream<BoxEvent> watchCategories() {
    return _box.watch();
  }
}
