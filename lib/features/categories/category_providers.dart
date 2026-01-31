import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoryListProvider = StateNotifierProvider<CategoryListNotifier, List<Category>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryListNotifier(repository);
});

class CategoryListNotifier extends StateNotifier<List<Category>> {
  final CategoryRepository _repository;

  CategoryListNotifier(this._repository) : super([]) {
    loadCategories();
  }

  void loadCategories() {
    state = _repository.getCategories();
  }

  Future<void> addCategory(Category category) async {
    await _repository.addCategory(category);
    loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _repository.updateCategory(category);
    loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.deleteCategory(id);
    loadCategories();
  }
}

// Selected category filter provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
