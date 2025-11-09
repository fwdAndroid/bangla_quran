import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSettingsProvider extends ChangeNotifier {
  String _arabicFontFamily = 'Amiri';
  double _fontSize = 24.0;
  bool _showArabic = true;
  bool _showBangla = true;

  String get arabicFontFamily => _arabicFontFamily;
  double get fontSize => _fontSize;
  bool get showArabic => _showArabic;
  bool get showBangla => _showBangla;

  FontSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _arabicFontFamily = prefs.getString('arabicFontFamily') ?? 'Amiri';
    _fontSize = prefs.getDouble('fontSize') ?? 24.0;
    _showArabic = prefs.getBool('showArabic') ?? true;
    _showBangla = prefs.getBool('showBangla') ?? true;
    notifyListeners();
  }

  Future<void> updateFontFamily(String font) async {
    _arabicFontFamily = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('arabicFontFamily', font);
    notifyListeners();
  }

  Future<void> updateFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  Future<void> toggleShowArabic(bool value) async {
    _showArabic = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showArabic', value);
    notifyListeners();
  }

  Future<void> toggleShowBangla(bool value) async {
    _showBangla = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showBangla', value);
    notifyListeners();
  }

  Future<void> resetDefaults() async {
    _arabicFontFamily = 'Amiri';
    _fontSize = 24.0;
    _showArabic = true;
    _showBangla = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
