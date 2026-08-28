import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteTracksProvider =
    StateNotifierProvider<FavoriteTracksController, Set<String>>((ref) {
      return FavoriteTracksController();
    });

class FavoriteTracksController extends StateNotifier<Set<String>> {
  FavoriteTracksController() : super(const {}) {
    _load();
  }

  static const _key = 'mindvibe.favorite_tracks';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList(_key)?.toSet() ?? const {};
  }

  Future<void> toggle(String id) async {
    if (id.isEmpty) {
      return;
    }
    final next = {...state};
    if (!next.remove(id)) {
      next.add(id);
    }
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList());
  }

  bool contains(String id) => state.contains(id);
}
