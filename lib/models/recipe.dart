import 'package:flutter/material.dart';

enum RecipeCategory { breakfast, lunch, dinner, dessert, vegan }

extension RecipeCategoryLabel on RecipeCategory {
  String get label {
    switch (this) {
      case RecipeCategory.breakfast:
        return 'Petit-déjeuner';
      case RecipeCategory.lunch:
        return 'Déjeuner';
      case RecipeCategory.dinner:
        return 'Dîner';
      case RecipeCategory.dessert:
        return 'Dessert';
      case RecipeCategory.vegan:
        return 'Végan';
    }
  }

  IconData get icon {
    switch (this) {
      case RecipeCategory.breakfast:
        return Icons.free_breakfast;
      case RecipeCategory.lunch:
        return Icons.lunch_dining;
      case RecipeCategory.dinner:
        return Icons.dinner_dining;
      case RecipeCategory.dessert:
        return Icons.cake;
      case RecipeCategory.vegan:
        return Icons.eco;
    }
  }

  Color get color {
    switch (this) {
      case RecipeCategory.breakfast:
        return Colors.orange;
      case RecipeCategory.lunch:
        return Colors.teal;
      case RecipeCategory.dinner:
        return Colors.indigo;
      case RecipeCategory.dessert:
        return Colors.pink;
      case RecipeCategory.vegan:
        return Colors.green;
    }
  }
}

enum Difficulty { facile, moyen, difficile }

extension DifficultyLabel on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.facile:
        return 'Facile';
      case Difficulty.moyen:
        return 'Moyen';
      case Difficulty.difficile:
        return 'Difficile';
    }
  }
}

@immutable
class Recipe {
  final String id;
  final String title;
  final String description;
  final RecipeCategory category;
  final Difficulty difficulty;
  final int prepTimeMinutes;
  final int servings;
  final double rating;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.servings,
    required this.rating,
    required this.ingredients,
    required this.steps,
    this.isFavorite = false,
  });

  Recipe copyWith({
    String? title,
    String? description,
    RecipeCategory? category,
    Difficulty? difficulty,
    int? prepTimeMinutes,
    int? servings,
    double? rating,
    List<String>? ingredients,
    List<String>? steps,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      servings: servings ?? this.servings,
      rating: rating ?? this.rating,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
