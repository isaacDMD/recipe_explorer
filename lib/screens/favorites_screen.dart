import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<RecipeProvider>().favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'Aucun favori pour l\'instant',
              message:
                  'Appuie sur le cœur d\'une recette pour l\'ajouter ici.',
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 600;
                  if (isTablet) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth >= 900 ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) => RecipeCard(
                        recipe: favorites[index],
                        onTap: () => context.pushNamed(
                          'recipeDetail',
                          pathParameters: {'id': favorites[index].id},
                        ),
                        onFavoriteToggle: () => context
                            .read<RecipeProvider>()
                            .toggleFavorite(favorites[index].id),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: favorites.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => RecipeCard(
                      recipe: favorites[index],
                      onTap: () => context.pushNamed(
                        'recipeDetail',
                        pathParameters: {'id': favorites[index].id},
                      ),
                      onFavoriteToggle: () => context
                          .read<RecipeProvider>()
                          .toggleFavorite(favorites[index].id),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
