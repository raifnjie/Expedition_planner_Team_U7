import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool aiSuggestions = true;
  String selectedUnit = 'Miles / lbs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
              title: const Text('Dark Mode'),
              subtitle: const Text('Choose theme'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Measurement Units'),
              subtitle: Text(selectedUnit),
              trailing: DropdownButton<String>(
                value: selectedUnit,
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
                    setState(() {
                      selectedUnit = value;
                    });
                  }
                },
              ),
            ),
          ),
          Card(
            child: SwitchListTile(
              value: aiSuggestions,
              onChanged: (value) {
                setState(() {
                  aiSuggestions = value;
                });
              },
              title: const Text('AI Suggestions'),
              subtitle: const Text('AI assistance option'),
            ),
          ),
        ],
      ),
    );
  }
}