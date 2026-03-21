import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool aiSuggestions = true;
  String selectedUnit = 'Miles / lbs';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      aiSuggestions = prefs.getBool('aiSuggestions') ?? true;
      selectedUnit = prefs.getString('selectedUnit') ?? 'Miles / lbs';
      isLoading = false;
    });
  }

  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      darkMode = value;
    });
  }

  Future<void> saveAiSuggestions(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('aiSuggestions', value);
    setState(() {
      aiSuggestions = value;
    });
  }

  Future<void> saveUnits(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedUnit', value);
    setState(() {
      selectedUnit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: SwitchListTile(
                    value: darkMode,
                    onChanged: saveDarkMode,
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Saved locally'),
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
                          saveUnits(value);
                        }
                      },
                    ),
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    value: aiSuggestions,
                    onChanged: saveAiSuggestions,
                    title: const Text('AI Suggestions'),
                    subtitle: const Text('Saved locally'),
                  ),
                ),
              ],
            ),
    );
  }
}