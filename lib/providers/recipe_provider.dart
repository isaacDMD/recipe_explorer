import 'package:flutter/foundation.dart';

import '../data/recipe_repository.dart';
import '../models/recipe.dart';

/// Détient la liste des recettes (données de démonstration + recettes
/// ajoutées via le formulaire) et l'état des favoris. Les écrans ne
/// contiennent aucune donnée en dur : ils lisent tout via ce provider.
class RecipeProvider extends ChangeNotifier {
  RecipeProvider() : _recipes = RecipeRepository.seedRecipes();

  final List<Recipe> _recipes;

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  List<Recipe> get favorites =>
      List.unmodifiable(_recipes.where((r) => r.isFavorite));

  Recipe? byId(String id) {
    for (final recipe in _recipes) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  void toggleFavorite(String id) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index == -1) return;
    _recipes[index] = _recipes[index].copyWith(
      isFavorite: !_recipes[index].isFavorite,
    );
    notifyListeners();
  }

  void addRecipe({
    required String title,
    required String description,
    required RecipeCategory category,
    required Difficulty difficulty,
    required int prepTimeMinutes,
    required int servings,
  }) {
    final id = 'user_${DateTime.now().microsecondsSinceEpoch}';
    _recipes.insert(
      0,
      Recipe(
        id: id,
        title: title,
        description: description,
        category: category,
        difficulty: difficulty,
        prepTimeMinutes: prepTimeMinutes,
        servings: servings,
        rating: 0,
        ingredients: const [],
        steps: const [],
      ),
    );
    notifyListeners();
  }
}
