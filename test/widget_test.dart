import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:recipe_explorer/app.dart';
import 'package:recipe_explorer/providers/recipe_provider.dart';
import 'package:recipe_explorer/providers/theme_provider.dart';

void main() {
  Widget buildApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const RecipeExplorerApp(),
    );
  }

  testWidgets('Home screen lists seeded recipes and can navigate to details',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Recipe Explorer'), findsOneWidget);
    expect(find.text('Pancakes moelleux'), findsOneWidget);

    await tester.tap(find.text('Pancakes moelleux'));
    await tester.pumpAndSettle();

    expect(find.text('Ingrédients'), findsOneWidget);
  });

  testWidgets('Search field filters the recipe list', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Fondant');
    await tester.pumpAndSettle();

    expect(find.text('Fondant au chocolat'), findsOneWidget);
    expect(find.text('Pancakes moelleux'), findsNothing);
  });

  testWidgets('Add recipe form validates required fields', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enregistrer la recette'));
    await tester.pumpAndSettle();

    expect(find.text('Le titre est obligatoire.'), findsOneWidget);
  });
}
