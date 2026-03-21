import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expedition.dart';
import '../theme/app_theme.dart';

class AppSettings extends ChangeNotifier {
  static final AppSettings instance = AppSettings._internal();

  AppSettings._internal();

  ThemeMode _themeMode = ThemeMode.light;
  String _accentColorName = 'Green';
  String _selectedUnit = 'Miles / lbs';
  bool _aiSuggestionsEnabled = true;
  int? _lastOpenedExpeditionId;
  String? _lastOpenedExpeditionName;

  ThemeMode get themeMode => _themeMode;
  String get accentColorName => _accentColorName;
  String get selectedUnit => _selectedUnit;
  bool get aiSuggestionsEnabled => _aiSuggestionsEnabled;
  int? get lastOpenedExpeditionId => _lastOpenedExpeditionId;
  String? get lastOpenedExpeditionName => _lastOpenedExpeditionName;

  Color get accentColor =>
      AppTheme.accentOptions[_accentColorName] ?? AppTheme.accentOptions['Green']!;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final storedTheme = prefs.getString('themeMode') ?? 'light';
    _themeMode = _parseThemeMode(storedTheme);
    _accentColorName = prefs.getString('accentColorName') ?? 'Green';
    _selectedUnit = prefs.getString('selectedUnit') ?? 'Miles / lbs';
    _aiSuggestionsEnabled = prefs.getBool('aiSuggestions') ?? true;
    _lastOpenedExpeditionId = prefs.getInt('lastOpenedExpeditionId');
    _lastOpenedExpeditionName = prefs.getString('lastOpenedExpeditionName');
  }

  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  String get themeModeLabel {
    switch (_themeMode) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
    }
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'themeMode',
      value == ThemeMode.dark
          ? 'dark'
          : value == ThemeMode.system
              ? 'system'
              : 'light',
    );
    notifyListeners();
  }

  Future<void> setAccentColorName(String value) async {
    _accentColorName = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accentColorName', value);
    notifyListeners();
  }

  Future<void> setSelectedUnit(String value) async {
    _selectedUnit = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedUnit', value);
    notifyListeners();
  }

  Future<void> setAiSuggestionsEnabled(bool value) async {
    _aiSuggestionsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('aiSuggestions', value);
    notifyListeners();
  }

  Future<void> setLastOpenedExpedition(Expedition expedition) async {
    _lastOpenedExpeditionId = expedition.id;
    _lastOpenedExpeditionName = expedition.name;

    final prefs = await SharedPreferences.getInstance();
    if (expedition.id != null) {
      await prefs.setInt('lastOpenedExpeditionId', expedition.id!);
    }
    await prefs.setString('lastOpenedExpeditionName', expedition.name);
    notifyListeners();
  }

  Future<void> clearLastOpenedExpedition() async {
    _lastOpenedExpeditionId = null;
    _lastOpenedExpeditionName = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastOpenedExpeditionId');
    await prefs.remove('lastOpenedExpeditionName');
    notifyListeners();
  }
}