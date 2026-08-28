import 'package:flutter/material.dart';
import 'package:mindvibe_app/features/exercises/domain/breathing_cycle.dart';
import 'package:mindvibe_app/features/exercises/domain/daily_drills.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class ExerciseTypeGroup {
  const ExerciseTypeGroup({required this.type, required this.items});

  final String type;
  final List<ExerciseSpec> items;
}

const exerciseTypeOrder = ['daily', 'breathing', 'attention', 'memory'];

List<ExerciseTypeGroup> groupExercisesByType(List<ExerciseSpec> items) {
  final map = <String, List<ExerciseSpec>>{};
  for (final item in items) {
    map.putIfAbsent(item.type, () => []).add(item);
  }
  final groups = <ExerciseTypeGroup>[];
  for (final type in exerciseTypeOrder) {
    final bucket = map.remove(type);
    if (bucket != null && bucket.isNotEmpty) {
      groups.add(ExerciseTypeGroup(type: type, items: bucket));
    }
  }
  for (final entry in map.entries) {
    if (entry.value.isNotEmpty) {
      groups.add(ExerciseTypeGroup(type: entry.key, items: entry.value));
    }
  }
  return groups;
}

IconData exerciseTypeIcon(String type) {
  return switch (type) {
    'breathing' => Icons.self_improvement_outlined,
    'attention' => Icons.center_focus_strong_outlined,
    'memory' => Icons.psychology_outlined,
    'daily' => Icons.fitness_center_outlined,
    _ => Icons.fitness_center_outlined,
  };
}

String exerciseTypeLabel(AppLocalizations l10n, String type) {
  return switch (type) {
    'breathing' => l10n.homeExerciseBreathing,
    'attention' => l10n.homeExerciseAttention,
    'memory' => l10n.homeExerciseMemory,
    'daily' => l10n.dailyHubTitle,
    _ => type,
  };
}

String exerciseVariantOf(ExerciseSpec exercise) {
  final fromField = exercise.variant?.trim();
  if (fromField != null && fromField.isNotEmpty) {
    return fromField;
  }
  final fromConfig = exercise.configuration?['variant'] as String?;
  if (fromConfig != null && fromConfig.isNotEmpty) {
    return fromConfig;
  }
  return switch (exercise.type) {
    'memory' => 'words',
    'attention' => 'target',
    'breathing' => 'wave',
    'daily' => 'observe',
    _ => '',
  };
}

int memoryWordCountOf(ExerciseSpec exercise) {
  return (exercise.configuration?['word_count'] as num?)?.toInt() ?? 6;
}

({Color accent, IconData icon}) breathingLook(ExerciseSpec exercise) {
  return switch (breathingVariantFrom(exerciseVariantOf(exercise))) {
    BreathingVariant.wave => (
      accent: const Color(0xFF7EC49A),
      icon: Icons.radio_button_unchecked,
    ),
    BreathingVariant.box => (
      accent: const Color(0xFF2F7A8A),
      icon: Icons.crop_square_outlined,
    ),
    BreathingVariant.ladder => (
      accent: const Color(0xFF8B6BB5),
      icon: Icons.view_stream_outlined,
    ),
    BreathingVariant.tide => (
      accent: const Color(0xFF3D7A9A),
      icon: Icons.waves_outlined,
    ),
  };
}

({Color accent, IconData icon}) memoryLook(ExerciseSpec exercise) {
  return switch (memoryVariantFrom(exerciseVariantOf(exercise))) {
    MemoryVariant.words => (
      accent: const Color(0xFF7EC49A),
      icon: Icons.menu_book_outlined,
    ),
    MemoryVariant.icons => (
      accent: const Color(0xFF6EA8E8),
      icon: Icons.image_outlined,
    ),
    MemoryVariant.order => (
      accent: const Color(0xFFB5A4E0),
      icon: Icons.format_list_numbered_outlined,
    ),
    MemoryVariant.delayed => (
      accent: const Color(0xFFE08A58),
      icon: Icons.hourglass_bottom_outlined,
    ),
  };
}

({Color accent, IconData icon}) attentionLook(ExerciseSpec exercise) {
  return switch (attentionVariantFrom(exerciseVariantOf(exercise))) {
    AttentionVariant.target => (
      accent: const Color(0xFFE08A58),
      icon: Icons.filter_center_focus_outlined,
    ),
    AttentionVariant.nogo => (
      accent: const Color(0xFFB5A4E0),
      icon: Icons.block_outlined,
    ),
    AttentionVariant.change => (
      accent: const Color(0xFF3D9A6A),
      icon: Icons.swap_horiz_outlined,
    ),
    AttentionVariant.grid => (
      accent: const Color(0xFF6EA8E8),
      icon: Icons.grid_view_outlined,
    ),
  };
}

String breathingMeta(AppLocalizations l10n, ExerciseSpec exercise) {
  return switch (breathingVariantFrom(exerciseVariantOf(exercise))) {
    BreathingVariant.wave => l10n.libraryBreathingKindWave,
    BreathingVariant.box => l10n.libraryBreathingKindBox,
    BreathingVariant.ladder => l10n.libraryBreathingKindLadder,
    BreathingVariant.tide => l10n.libraryBreathingKindTide,
  };
}

String memoryMeta(AppLocalizations l10n, ExerciseSpec exercise) {
  return switch (memoryVariantFrom(exerciseVariantOf(exercise))) {
    MemoryVariant.words => l10n.libraryMemoryKindWords,
    MemoryVariant.icons => l10n.libraryMemoryKindIcons,
    MemoryVariant.order => l10n.libraryMemoryKindOrder,
    MemoryVariant.delayed => l10n.libraryMemoryKindDelayed,
  };
}

String attentionMeta(AppLocalizations l10n, ExerciseSpec exercise) {
  return switch (attentionVariantFrom(exerciseVariantOf(exercise))) {
    AttentionVariant.target => l10n.libraryAttentionKindTarget,
    AttentionVariant.nogo => l10n.libraryAttentionKindNogo,
    AttentionVariant.change => l10n.libraryAttentionKindChange,
    AttentionVariant.grid => l10n.libraryAttentionKindGrid,
  };
}

List<ExerciseSpec> sortedBreathingExercises(List<ExerciseSpec> items) {
  const order = {'wave': 0, 'box': 1, 'ladder': 2, 'tide': 3};
  final copy = [...items];
  copy.sort((a, b) {
    return (order[exerciseVariantOf(a)] ?? 9).compareTo(
      order[exerciseVariantOf(b)] ?? 9,
    );
  });
  return copy;
}

List<ExerciseSpec> sortedMemoryExercises(List<ExerciseSpec> items) {
  const order = {'words': 0, 'icons': 1, 'order': 2, 'delayed': 3};
  final copy = [...items];
  copy.sort((a, b) {
    final byKind = (order[exerciseVariantOf(a)] ?? 9).compareTo(
      order[exerciseVariantOf(b)] ?? 9,
    );
    if (byKind != 0) {
      return byKind;
    }
    return memoryWordCountOf(a).compareTo(memoryWordCountOf(b));
  });
  return copy;
}

List<ExerciseSpec> sortedAttentionExercises(List<ExerciseSpec> items) {
  const order = {'target': 0, 'nogo': 1, 'change': 2, 'grid': 3};
  final copy = [...items];
  copy.sort((a, b) {
    return (order[exerciseVariantOf(a)] ?? 9).compareTo(
      order[exerciseVariantOf(b)] ?? 9,
    );
  });
  return copy;
}

({Color accent, IconData icon}) dailyLook(ExerciseSpec exercise) {
  return switch (dailyVariantFrom(exerciseVariantOf(exercise))) {
    DailyVariant.observe => (
      accent: const Color(0xFF6EA8E8),
      icon: Icons.visibility_outlined,
    ),
    DailyVariant.reverse => (
      accent: const Color(0xFFB5A4E0),
      icon: Icons.swap_vert,
    ),
    DailyVariant.categories => (
      accent: const Color(0xFFE08A58),
      icon: Icons.category_outlined,
    ),
    DailyVariant.retell => (
      accent: const Color(0xFF7EC49A),
      icon: Icons.menu_book_outlined,
    ),
    DailyVariant.countdown => (
      accent: const Color(0xFF2F7A8A),
      icon: Icons.filter_3,
    ),
    DailyVariant.senses => (
      accent: const Color(0xFF8FB4A8),
      icon: Icons.spa_outlined,
    ),
    DailyVariant.singleTask => (
      accent: const Color(0xFFC46A3A),
      icon: Icons.timer_outlined,
    ),
    DailyVariant.uses => (
      accent: const Color(0xFF8B6BB5),
      icon: Icons.lightbulb_outline,
    ),
    DailyVariant.sort => (
      accent: const Color(0xFFD7B49A),
      icon: Icons.edit_note_outlined,
    ),
    DailyVariant.silence => (
      accent: const Color(0xFF6B6B8A),
      icon: Icons.self_improvement_outlined,
    ),
  };
}

String dailyMeta(AppLocalizations l10n, ExerciseSpec exercise) {
  return switch (dailyVariantFrom(exerciseVariantOf(exercise))) {
    DailyVariant.observe => l10n.dailyMetaObserve,
    DailyVariant.reverse => l10n.dailyMetaReverse,
    DailyVariant.categories => l10n.dailyMetaCategories,
    DailyVariant.retell => l10n.dailyMetaRetell,
    DailyVariant.countdown => l10n.dailyMetaCountdown,
    DailyVariant.senses => l10n.dailyMetaSenses,
    DailyVariant.singleTask => l10n.dailyMetaTask,
    DailyVariant.uses => l10n.dailyMetaUses,
    DailyVariant.sort => l10n.dailyMetaSort,
    DailyVariant.silence => l10n.dailyMetaSilence,
  };
}

List<ExerciseSpec> sortedDailyExercises(List<ExerciseSpec> items) {
  const order = {
    'observe': 0,
    'reverse': 1,
    'categories': 2,
    'retell': 3,
    'countdown': 4,
    'senses': 5,
    'single_task': 6,
    'uses': 7,
    'sort': 8,
    'silence': 9,
  };
  final copy = [...items];
  copy.sort((a, b) {
    return (order[exerciseVariantOf(a)] ?? 9).compareTo(
      order[exerciseVariantOf(b)] ?? 9,
    );
  });
  return copy;
}
