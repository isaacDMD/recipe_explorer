import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_filter_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  RecipeCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> _filter(List<Recipe> recipes) {
    return recipes.where((recipe) {
      final matchesQuery = _query.isEmpty ||
          recipe.title.toLowerCase().contains(_query.toLowerCase()) ||
          recipe.description.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || recipe.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = context.watch<RecipeProvider>().recipes;
    final filtered = _filter(recipes);

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Explorer')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('addRecipe'),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchFilterBar(
              controller: _searchController,
              onQueryChanged: (value) => setState(() => _query = value),
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) =>
                  setState(() => _selectedCategory = category),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off,
                      title: 'Aucune recette trouvée',
                      message:
                          'Essaie un autre mot-clé ou une autre catégorie.',
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isTablet = constraints.maxWidth >= 600;
                        if (isTablet) {
                          return GridView.builder(
                            padding: const EdgeInsets.only(bottom: 88),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  constraints.maxWidth >= 900 ? 3 : 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) => _buildCard(
                              context,
                              filtered[index],
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 88),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) => _buildCard(
                            context,
                            filtered[index],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Recipe recipe) {
    return RecipeCard(
      recipe: recipe,
      onTap: () => context.pushNamed(
        'recipeDetail',
        pathParameters: {'id': recipe.id},
      ),
      onFavoriteToggle: () =>
          context.read<RecipeProvider>().toggleFavorite(recipe.id),
    );
  }
}
