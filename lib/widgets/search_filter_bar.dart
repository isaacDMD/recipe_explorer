import 'package:flutter/material.dart';

import '../models/recipe.dart';

/// Barre de recherche + filtres par catégorie, réutilisable partout où une
/// liste de recettes doit être filtrée. Ne détient aucune donnée : tout
/// transite par les paramètres et callbacks.
class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.onQueryChanged,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final TextEditingController controller;
  final ValueChanged<String> onQueryChanged;
  final RecipeCategory? selectedCategory;
  final ValueChanged<RecipeCategory?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: onQueryChanged,
          decoration: const InputDecoration(
            hintText: 'Rechercher une recette...',
            prefixIcon: Icon(Icons.search),
            isDense: true,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _CategoryChip(
                label: 'Toutes',
                selected: selectedCategory == null,
                onSelected: () => onCategorySelected(null),
              ),
              const SizedBox(width: 8),
              for (final category in RecipeCategory.values) ...[
                _CategoryChip(
                  label: category.label,
                  selected: selectedCategory == category,
                  onSelected: () => onCategorySelected(category),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
