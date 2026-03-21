import 'package:flutter/material.dart';
import '../services/app_settings.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        final settings = AppSettings.instance;
        final scheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Theme Mode'),
                  subtitle: Text(settings.themeModeLabel),
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        settings.setThemeMode(value);
                      }
                    },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Accent Color'),
                  subtitle: Row(
                    children: [
                      Text(settings.accentColorName),
                      const SizedBox(width: 10),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: settings.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  trailing: DropdownButton<String>(
                    value: settings.accentColorName,
                    underline: const SizedBox(),
                    items: AppTheme.accentOptions.keys
                        .map(
                          (name) => DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        settings.setAccentColorName(value);
                      }
                    },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Measurement Units'),
                  subtitle: Text(settings.selectedUnit),
                  trailing: DropdownButton<String>(
                    value: settings.selectedUnit,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Miles / lbs',
                        child: Text('Miles / lbs'),
                      ),
                      DropdownMenuItem(
                        value: 'Km / kg',
                        child: Text('Km / kg'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        settings.setSelectedUnit(value);
                      }
                    },
                  ),
                ),
              ),
              Card(
                child: SwitchListTile(
                  value: settings.aiSuggestionsEnabled,
                  onChanged: settings.setAiSuggestionsEnabled,
                  title: const Text('AI Suggestions'),
                  subtitle: const Text('Saved locally'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.explore, color: scheme.primary),
                  title: const Text('Last Opened Expedition'),
                  subtitle: Text(
                    settings.lastOpenedExpeditionName ?? 'None yet',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}