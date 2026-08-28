import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appearanceProvider =
    StateNotifierProvider<AppearanceController, ThemeMode>((ref) {
      return AppearanceController();
    });

class AppearanceController extends StateNotifier<ThemeMode> {
  AppearanceController() : super(ThemeMode.light) {
    _load();
  }

  static const _key = 'appearance_theme';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    state = prefs.getString(_key) == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDark(bool dark) async {
    state = dark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, dark ? 'dark' : 'light');
  }
}
