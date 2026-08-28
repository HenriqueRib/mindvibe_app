import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomeLayoutKind { today, training, progress }

final homeLayoutProvider =
    StateNotifierProvider<HomeLayoutController, HomeLayoutKind>((ref) {
      return HomeLayoutController();
    });

class HomeLayoutController extends StateNotifier<HomeLayoutKind> {
  HomeLayoutController() : super(HomeLayoutKind.today) {
    _load();
  }

  static const _key = 'home_layout';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    state = parse(prefs.getString(_key));
  }

  Future<void> setKind(HomeLayoutKind kind) async {
    state = kind;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, kind.name);
  }

  static HomeLayoutKind parse(String? raw) {
    return switch (raw) {
      'training' => HomeLayoutKind.training,
      'progress' => HomeLayoutKind.progress,
      _ => HomeLayoutKind.today,
    };
  }
}
