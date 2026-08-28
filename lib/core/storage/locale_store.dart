import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController();
});

class AppLocale {
  const AppLocale._();

  static const portuguese = Locale('pt', 'BR');
  static const english = Locale('en');
  static const fallback = portuguese;

  static const options = [portuguese, english];

  static Locale parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return fallback;
    }
    final language = raw
        .trim()
        .replaceAll('_', '-')
        .split('-')
        .first
        .toLowerCase();
    if (language == 'en') {
      return english;
    }
    return portuguese;
  }

  static String encode(Locale locale) {
    if (locale.languageCode.toLowerCase() == 'en') {
      return 'en';
    }
    return 'pt-BR';
  }

  static bool matches(Locale a, Locale b) {
    return a.languageCode.toLowerCase() == b.languageCode.toLowerCase();
  }
}

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(AppLocale.fallback) {
    _loadFuture = _load();
  }

  static const _key = 'app_locale';

  late final Future<void> _loadFuture;
  bool _hasExplicit = false;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    final raw = prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      _hasExplicit = true;
      state = AppLocale.parse(raw);
    }
  }

  Future<void> applyFromAccount(String? localeTag) async {
    await _loadFuture;
    if (!mounted || _hasExplicit) {
      return;
    }
    if (localeTag == null || localeTag.isEmpty) {
      return;
    }
    state = AppLocale.parse(localeTag);
  }

  Future<void> setLocale(Locale locale) async {
    final next = AppLocale.parse(AppLocale.encode(locale));
    state = next;
    _hasExplicit = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, AppLocale.encode(next));
  }
}
