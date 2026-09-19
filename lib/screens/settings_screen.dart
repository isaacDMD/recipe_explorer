import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RadioGroup<ThemeMode>(
            groupValue: themeProvider.themeMode,
            onChanged: (mode) => themeProvider.setThemeMode(mode!),
            child: const Card(
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text('Suivre le système'),
                    secondary: Icon(Icons.brightness_auto),
                    value: ThemeMode.system,
                  ),
                  Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    title: Text('Thème clair'),
                    secondary: Icon(Icons.light_mode_outlined),
                    value: ThemeMode.light,
                  ),
                  Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    title: Text('Thème sombre'),
                    secondary: Icon(Icons.dark_mode_outlined),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              title: const Text('Mode sombre rapide'),
              subtitle: const Text('Bascule directe entre clair et sombre'),
              secondary: const Icon(Icons.contrast),
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleDark,
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Recipe Explorer'),
              subtitle: Text(
                'Application de démonstration Flutter — recettes, navigation et thèmes.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
