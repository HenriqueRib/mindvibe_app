import 'package:flutter/material.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class AudioLibraryCategory {
  const AudioLibraryCategory({
    required this.slug,
    required this.name,
    required this.sortOrder,
  });

  final String slug;
  final String name;
  final int sortOrder;
}

List<AudioLibraryCategory> uniqueAudioCategories(List<ListenMoment> items) {
  final map = <String, AudioLibraryCategory>{};
  for (final item in items) {
    if (item.categorySlug.isEmpty) {
      continue;
    }
    map.putIfAbsent(
      item.categorySlug,
      () => AudioLibraryCategory(
        slug: item.categorySlug,
        name: item.categoryName,
        sortOrder: item.categorySortOrder,
      ),
    );
  }
  final categories = map.values.toList()
    ..sort((a, b) {
      final byOrder = a.sortOrder.compareTo(b.sortOrder);
      if (byOrder != 0) {
        return byOrder;
      }
      return a.name.compareTo(b.name);
    });
  return categories;
}

IconData audioCategoryIcon(String slug) {
  return switch (slug) {
    'sleep' => Icons.bedtime_outlined,
    'relaxation' => Icons.spa_outlined,
    'breathing' => Icons.air,
    'memory' => Icons.menu_book_outlined,
    'focus' => Icons.center_focus_strong_outlined,
    'mindfulness' => Icons.self_improvement_outlined,
    _ => Icons.graphic_eq_rounded,
  };
}

String audioCategoryLabel(AppLocalizations l10n, String slug, String fallback) {
  return switch (slug) {
    'sleep' => l10n.homeNowSleep,
    'relaxation' => l10n.homeNowRelax,
    'breathing' => l10n.homeNowBreathe,
    'focus' => l10n.homeNowFocus,
    'memory' => l10n.homeNowMemory,
    'mindfulness' => l10n.homeNowMindfulness,
    _ => fallback,
  };
}
