import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  RecipeCategory _category = RecipeCategory.dinner;
  Difficulty _difficulty = Difficulty.facile;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<RecipeProvider>().addRecipe(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _category,
          difficulty: _difficulty,
          prepTimeMinutes: int.parse(_prepTimeController.text.trim()),
          servings: int.parse(_servingsController.text.trim()),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recette ajoutée avec succès !')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle recette')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de la recette',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Le titre est obligatoire.';
                if (text.length < 3) {
                  return 'Le titre doit contenir au moins 3 caractères.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'La description est obligatoire.';
                if (text.length < 10) {
                  return 'Ajoute au moins 10 caractères pour décrire le plat.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RecipeCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: [
                for (final category in RecipeCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(category.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
              validator: (value) =>
                  value == null ? 'Choisis une catégorie.' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Difficulty>(
              initialValue: _difficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulté',
                prefixIcon: Icon(Icons.speed),
              ),
              items: [
                for (final difficulty in Difficulty.values)
                  DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _difficulty = value);
              },
              validator: (value) =>
                  value == null ? 'Choisis une difficulté.' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _prepTimeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Temps (min)',
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      final parsed = int.tryParse(text);
                      if (text.isEmpty) return 'Requis';
                      if (parsed == null || parsed <= 0) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Portions',
                      prefixIcon: Icon(Icons.people_alt_outlined),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      final parsed = int.tryParse(text);
                      if (text.isEmpty) return 'Requis';
                      if (parsed == null || parsed <= 0) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Enregistrer la recette'),
            ),
          ],
        ),
      ),
    );
  }
}
