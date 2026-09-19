import 'package:flutter/material.dart';

import '../models/recipe.dart';
import 'rating_stars.dart';

/// Carte réutilisable pour représenter une recette dans une liste ou une
/// grille. Reçoit toutes ses données en paramètres : aucune donnée n'est
/// codée en dur ici.
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final category = recipe.category;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'recipe-banner-${recipe.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            category.color.withValues(alpha: 0.85),
                            category.color.withValues(alpha: 0.55),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(category.icon, size: 42, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _FavoriteButton(
                      isFavorite: recipe.isFavorite,
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Chip(
                      label: Text(category.label),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.black.withValues(alpha: 0.55),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 11),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14),
                      const SizedBox(width: 4),
                      Text('${recipe.prepTimeMinutes} min',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 12),
                      const Icon(Icons.people_alt_outlined, size: 14),
                      const SizedBox(width: 4),
                      Text('${recipe.servings}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      RatingStars(rating: recipe.rating, size: 13),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.4),
      shape: const CircleBorder(),
      child: IconButton(
        iconSize: 18,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: EdgeInsets.zero,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.redAccent : Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
