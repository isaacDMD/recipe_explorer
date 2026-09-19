import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_recipe_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/adaptive_scaffold.dart';

/// Toutes les routes nommées de l'application, centralisées ici.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const recipeDetail = '/recipe/:id';
  static const addRecipe = '/add';

  static String recipeDetailPath(String id) => '/recipe/$id';
}

/// Construit une nouvelle instance de routeur. Utilisé comme une fabrique
/// (plutôt qu'un singleton top-level) pour que chaque instance de l'app —
/// notamment dans les tests, où l'app est reconstruite plusieurs fois dans
/// le même isolat — reparte d'une pile de navigation propre.
GoRouter createAppRouter() {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                name: 'favorites',
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.recipeDetail,
        name: 'recipeDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RecipeDetailScreen(recipeId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.addRecipe,
        name: 'addRecipe',
        builder: (context, state) => const AddRecipeScreen(),
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: navigationShell,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: const [
        AdaptiveDestination(
          icon: Icons.restaurant_menu_outlined,
          selectedIcon: Icons.restaurant_menu,
          label: 'Recettes',
        ),
        AdaptiveDestination(
          icon: Icons.favorite_border,
          selectedIcon: Icons.favorite,
          label: 'Favoris',
        ),
        AdaptiveDestination(
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          label: 'Réglages',
        ),
      ],
    );
  }
}
