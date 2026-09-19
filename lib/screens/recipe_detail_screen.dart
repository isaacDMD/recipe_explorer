import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/rating_stars.dart';

/// Écran de détail : reçoit uniquement l'identifiant de la recette via
/// GoRouter (paramètre de route `:id`) et va chercher les données à jour
/// dans le provider, plutôt que de recevoir un objet figé.
class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final recipe = context.watch<RecipeProvider>().byId(recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Recette introuvable.')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.redAccent : null,
                ),
                onPressed: () =>
                    context.read<RecipeProvider>().toggleFavorite(recipe.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(recipe.title),
              background: Hero(
                tag: 'recipe-banner-${recipe.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        recipe.category.color.withValues(alpha: 0.9),
                        recipe.category.color.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(recipe.category.icon,
                        size: 72, color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(recipe.category.icon, size: 16),
                        label: Text(recipe.category.label),
                      ),
                      Chip(
                        avatar: const Icon(Icons.speed, size: 16),
                        label: Text(recipe.difficulty.label),
                      ),
                      Chip(
                        avatar: const Icon(Icons.timer_outlined, size: 16),
                        label: Text('${recipe.prepTimeMinutes} min'),
                      ),
                      Chip(
                        avatar: const Icon(Icons.people_alt_outlined, size: 16),
                        label: Text('${recipe.servings} pers.'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (recipe.rating > 0)
                    Row(
                      children: [
                        RatingStars(rating: recipe.rating, size: 20),
                        const SizedBox(width: 8),
                        Text(recipe.rating.toStringAsFixed(1)),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (recipe.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Ingrédients',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...recipe.ingredients.map(
                      (ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ingredient)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (recipe.steps.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Préparation',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...recipe.steps.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: Text(entry.value)),
                              ],
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
