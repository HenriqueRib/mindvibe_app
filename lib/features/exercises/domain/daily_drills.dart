import 'dart:math';

import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';

enum DailyVariant {
  observe,
  reverse,
  categories,
  retell,
  countdown,
  senses,
  singleTask,
  uses,
  sort,
  silence,
}

DailyVariant dailyVariantFrom(String? raw) {
  return switch ((raw ?? '').toLowerCase()) {
    'observe' => DailyVariant.observe,
    'reverse' => DailyVariant.reverse,
    'categories' => DailyVariant.categories,
    'retell' => DailyVariant.retell,
    'countdown' => DailyVariant.countdown,
    'senses' => DailyVariant.senses,
    'single_task' || 'singletask' => DailyVariant.singleTask,
    'uses' || 'creativity' => DailyVariant.uses,
    'sort' || 'journal' => DailyVariant.sort,
    'silence' => DailyVariant.silence,
    _ => DailyVariant.observe,
  };
}

String dailyVariantName(DailyVariant variant) {
  return switch (variant) {
    DailyVariant.observe => 'observe',
    DailyVariant.reverse => 'reverse',
    DailyVariant.categories => 'categories',
    DailyVariant.retell => 'retell',
    DailyVariant.countdown => 'countdown',
    DailyVariant.senses => 'senses',
    DailyVariant.singleTask => 'single_task',
    DailyVariant.uses => 'uses',
    DailyVariant.sort => 'sort',
    DailyVariant.silence => 'silence',
  };
}

int dailyDefaultSeconds(DailyVariant variant) {
  return switch (variant) {
    DailyVariant.observe => 120,
    DailyVariant.reverse => 90,
    DailyVariant.categories => 180,
    DailyVariant.retell => 180,
    DailyVariant.countdown => 300,
    DailyVariant.senses => 90,
    DailyVariant.singleTask => 600,
    DailyVariant.uses => 180,
    DailyVariant.sort => 300,
    DailyVariant.silence => 300,
  };
}

const dailyObservePrompts = ['Cor', 'Formato', 'Textura', 'Detalhes pequenos'];

const dailyObserveObjects = [
  'uma planta',
  'a palma da mão',
  'um copo',
  'a janela',
  'um livro',
  'um objeto à sua frente',
];

const dailyUseObjects = [
  'uma garrafa',
  'um clipe',
  'um jornal',
  'uma colher',
  'uma caixa',
  'um elástico',
  'uma chave',
  'um copo',
];

const dailyCategoryLetters = ['A', 'B', 'C', 'F', 'L', 'M', 'P', 'S'];

const dailySingleTasks = ['Ler', 'Arrumar', 'Cozinhar', 'Caminhar', 'Escrever'];

const dailyRetellTexts = [
  'O café esfriou na mesa. A janela estava aberta. Um pássaro parou no parapeito e depois voou.',
  'A rua molhada refletia os postes. Alguém passou de bicicleta sem pressa. O pão ainda cheirava no saco.',
  'A planta na varanda cresceu torta em busca de sol. Ninguém a virou. Mesmo assim, ela persistiu.',
];

const dailyReverseWords = [
  'casa',
  'mesa',
  'livro',
  'água',
  'planta',
  'janela',
  'nuvem',
  'pedra',
  'ponte',
  'chave',
  'rio',
  'sol',
  'lua',
  'mar',
  'flor',
  'pão',
  'café',
  'porta',
];

const dailyReverseObjects = [
  '🌙',
  '🌿',
  '☕',
  '📖',
  '🌊',
  '🪨',
  '🔔',
  '🍎',
  '🔑',
  '🌸',
  '🚲',
  '⭐',
];

class ReverseRound {
  const ReverseRound({required this.items});

  final List<String> items;

  List<String> get expected => items.reversed.toList();

  List<String> shuffledOptions([Random? random]) {
    final options = [...items]..shuffle(random ?? Random());
    return options;
  }
}

List<String> pickUnique(List<String> pool, int count, Random rng) {
  final copy = [...pool]..shuffle(rng);
  return copy.take(count).toList();
}

ReverseRound randomReverseRound({Random? random}) {
  final rng = random ?? Random();
  return switch (rng.nextInt(3)) {
    0 => ReverseRound(
      items: pickUnique(
        const ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
        5,
        rng,
      ),
    ),
    1 => ReverseRound(items: pickUnique(dailyReverseWords, 5, rng)),
    _ => ReverseRound(items: pickUnique(dailyReverseObjects, 5, rng)),
  };
}

enum DailyFamily { focus, memory, presence, create }

DailyFamily dailyFamilyOf(DailyVariant variant) {
  return switch (variant) {
    DailyVariant.observe ||
    DailyVariant.countdown ||
    DailyVariant.singleTask => DailyFamily.focus,
    DailyVariant.reverse ||
    DailyVariant.categories ||
    DailyVariant.retell => DailyFamily.memory,
    DailyVariant.senses ||
    DailyVariant.sort ||
    DailyVariant.silence => DailyFamily.presence,
    DailyVariant.uses => DailyFamily.create,
  };
}

const dailyCategoryNames = ['Animais', 'Comidas', 'Profissões', 'Lugares'];

List<int> randomDigits(int count, {Random? random}) {
  final rng = random ?? Random();
  return [for (var i = 0; i < count; i++) rng.nextInt(9) + 1];
}

List<int> countdownChoices(int current, {Random? random}) {
  final rng = random ?? Random();
  final expected = current - 3;
  final pool = {current - 6, current - 4, current - 2, current - 1, current + 3}
    ..remove(expected)
    ..removeWhere((value) => value < 0);
  final others = pool.toList()..shuffle(rng);
  final picks = [expected, ...others.take(2)]..shuffle(rng);
  return picks;
}

String randomPick(List<String> items, {Random? random}) {
  final rng = random ?? Random();
  return items[rng.nextInt(items.length)];
}

bool isDailyTypedAnswer(String value) {
  return value.trim().length >= 2;
}

int dailyRetellFilled(String text) {
  final trimmed = text.trim();
  if (trimmed.length < 12) {
    return 0;
  }
  final words = trimmed
      .split(RegExp(r'\s+'))
      .where((word) => word.replaceAll(RegExp(r'[^\wÀ-ÿ]'), '').length >= 2);
  return words.length >= 3 ? 1 : 0;
}

int dailyMinEffort(DailyVariant variant) {
  return switch (variant) {
    DailyVariant.categories => 5,
    DailyVariant.retell => 1,
    DailyVariant.senses => 1,
    DailyVariant.uses => 5,
    DailyVariant.sort => 1,
    DailyVariant.countdown => 5,
    _ => 0,
  };
}

bool dailyCanComplete({
  required DailyVariant variant,
  int filled = 0,
  int correct = 0,
}) {
  final min = dailyMinEffort(variant);
  if (min <= 0) {
    return true;
  }
  if (variant == DailyVariant.countdown) {
    return correct >= min;
  }
  return filled >= min;
}

bool progressLooksSaturated({
  int? mood,
  int? energy,
  bool hasTodayFocus = false,
}) {
  if (hasTodayFocus) {
    return true;
  }
  if (mood != null && mood <= 2) {
    return true;
  }
  if (energy != null && energy <= 2) {
    return true;
  }
  return false;
}

List<String> circuitVariants({required bool saturated, DateTime? now}) {
  if (saturated) {
    return const ['senses', 'sort', 'silence'];
  }
  final day = (now ?? DateTime.now()).day;
  final concentrate = day.isEven ? 'countdown' : 'observe';
  final memory = day % 3 == 0 ? 'categories' : 'reverse';
  return [concentrate, memory, 'uses'];
}

List<ExerciseSpec> pickCircuit(
  List<ExerciseSpec> library, {
  required bool saturated,
  DateTime? now,
}) {
  final wanted = circuitVariants(saturated: saturated, now: now);
  final byVariant = <String, ExerciseSpec>{};
  for (final item in library) {
    if (item.type != 'daily') {
      continue;
    }
    final variant = (item.variant ?? '').trim();
    if (variant.isNotEmpty) {
      byVariant[variant] = item;
    }
  }
  return [
    for (final variant in wanted)
      if (byVariant[variant] != null) byVariant[variant]!,
  ];
}
