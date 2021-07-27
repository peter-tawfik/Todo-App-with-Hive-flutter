import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light_mode = ThemeData(
  brightness: Brightness.light,
);

ThemeData dark_mode = ThemeData(
  brightness: Brightness.dark,
);

class ThemeNotifier extends ChangeNotifier {
  late SharedPreferences _preferences;
  late bool _isDark = false;

  bool get darkMode => _isDark;

  ThemeNotifier() {
    _loadFromPreferences();
  }

  _initialPreferences() async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences(bool isDark) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isDark', isDark);
  }

  _loadFromPreferences() async {
    final pref = await SharedPreferences.getInstance();
    _isDark = pref.getBool('isDark') ?? false;
    notifyListeners();
  }

  toggleChangeTheme() {
    _isDark = !_isDark;
    _savePreferences(_isDark);
    notifyListeners();
  }
}
