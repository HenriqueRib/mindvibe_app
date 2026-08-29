import 'dart:math';

class RatingConfig {
  const RatingConfig({
    required this.min,
    required this.max,
    this.prompt,
    this.labels = const {},
  });

  factory RatingConfig.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const <String, dynamic>{};
    final rawLabels = data['labels'];
    final labels = <int, String>{};
    if (rawLabels is Map) {
      for (final entry in rawLabels.entries) {
        final key = int.tryParse(entry.key.toString());
        if (key != null && entry.value != null) {
          labels[key] = entry.value.toString();
        }
      }
    }
    return RatingConfig(
      min: (data['min'] as num?)?.toInt() ?? 1,
      max: (data['max'] as num?)?.toInt() ?? 5,
      prompt: data['prompt'] as String?,
      labels: labels,
    );
  }

  final int min;
  final int max;
  final String? prompt;
  final Map<int, String> labels;
}

enum AttentionSymbol { circle, triangle, square }

enum AttentionVariant { target, nogo, change, grid }

enum MemoryVariant { words, icons, order, delayed }

AttentionSymbol attentionSymbolFrom(String? raw) {
  return switch ((raw ?? 'triangle').toLowerCase()) {
    'circle' || 'o' || '○' => AttentionSymbol.circle,
    'square' || '□' => AttentionSymbol.square,
    _ => AttentionSymbol.triangle,
  };
}

AttentionVariant attentionVariantFrom(String? raw) {
  return switch ((raw ?? 'target').toLowerCase()) {
    'nogo' || 'no-go' || 'inhibit' => AttentionVariant.nogo,
    'change' || 'shift' => AttentionVariant.change,
    'grid' || 'odd' => AttentionVariant.grid,
    _ => AttentionVariant.target,
  };
}

MemoryVariant memoryVariantFrom(String? raw) {
  return switch ((raw ?? 'words').toLowerCase()) {
    'icons' || 'images' || 'visual' => MemoryVariant.icons,
    'order' || 'sequence' => MemoryVariant.order,
    'delayed' || 'hold' || 'long' => MemoryVariant.delayed,
    _ => MemoryVariant.words,
  };
}

class AttentionConfig {
  const AttentionConfig({
    required this.durationSeconds,
    required this.target,
    required this.intervalMs,
    this.sequence = const [],
    this.variant = AttentionVariant.target,
  });

  factory AttentionConfig.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const <String, dynamic>{};
    final rawSequence = data['sequence'];
    final variant = attentionVariantFrom(data['variant'] as String?);
    return AttentionConfig(
      durationSeconds: (data['duration_seconds'] as num?)?.toInt() ?? 60,
      target: attentionSymbolFrom(data['target'] as String?),
      intervalMs:
          (data['interval_ms'] as num?)?.toInt() ??
          (variant == AttentionVariant.grid ? 2400 : 1500),
      sequence: rawSequence is List
          ? rawSequence
                .map((item) => attentionSymbolFrom(item.toString()))
                .toList()
          : const [],
      variant: variant,
    );
  }

  final int durationSeconds;
  final AttentionSymbol target;
  final int intervalMs;
  final List<AttentionSymbol> sequence;
  final AttentionVariant variant;
}

class AttentionRound {
  const AttentionRound({required this.symbol, required this.isTarget});

  final AttentionSymbol symbol;
  final bool isTarget;
}

class AttentionScore {
  const AttentionScore({
    required this.hits,
    required this.misses,
    required this.durationMs,
  });

  final int hits;
  final int misses;
  final int durationMs;
}

class AttentionEngine {
  AttentionEngine(this.config, {int Function(int max)? random})
    : _random = random ?? _defaultRandom;

  final AttentionConfig config;
  final int Function(int max) _random;
  int hits = 0;
  int misses = 0;
  int _index = 0;

  static int _defaultRandom(int max) =>
      DateTime.now().microsecondsSinceEpoch % max;

  AttentionRound nextRound() {
    final symbol = config.sequence.isNotEmpty
        ? config.sequence[_index % config.sequence.length]
        : AttentionSymbol.values[_random(AttentionSymbol.values.length)];
    _index += 1;
    return AttentionRound(symbol: symbol, isTarget: symbol == config.target);
  }

  void registerTap({required bool isTarget}) {
    if (isTarget) {
      hits += 1;
    } else {
      misses += 1;
    }
  }

  void registerMissedTarget() {
    misses += 1;
  }

  AttentionScore score(int durationMs) {
    return AttentionScore(hits: hits, misses: misses, durationMs: durationMs);
  }
}

class MemoryConfig {
  const MemoryConfig({
    required this.words,
    required this.options,
    required this.displaySeconds,
    this.variant = MemoryVariant.words,
    this.delaySeconds = 10,
  });

  factory MemoryConfig.fromJson(
    Map<String, dynamic>? json, {
    List<String> extraWords = const [],
    Random? random,
  }) {
    final data = json ?? const <String, dynamic>{};
    final variant = memoryVariantFrom(data['variant'] as String?);
    final wordCount = (_readInt(data['word_count'], 6)).clamp(3, 12);
    final displaySeconds = _readInt(
      data['display_seconds'],
      variant == MemoryVariant.order ? 2 : 8,
    );
    final delaySeconds = _readInt(data['delay_seconds'], 10);
    final provided = _cleanWords(data['words'] as List?);
    final distractors = _cleanWords(data['distractors'] as List?);
    final rng = random ?? Random();
    final useUserWords =
        variant == MemoryVariant.words || variant == MemoryVariant.delayed;
    final user = useUserWords
        ? (_uniqueWords(extraWords)..shuffle(rng))
        : <String>[];
    final pool = variant == MemoryVariant.icons
        ? _fallbackIcons
        : _fallbackWords;
    final rest =
        _uniqueWords([...provided, ...pool])
            .where(
              (word) =>
                  !user.any((item) => item.toLowerCase() == word.toLowerCase()),
            )
            .toList()
          ..shuffle(rng);
    final words = <String>[...user.take(wordCount)];
    if (words.length < wordCount) {
      words.addAll(rest.take(wordCount - words.length));
    }
    final used = {for (final word in words) word.toLowerCase()};
    final leftover =
        _uniqueWords([
            ...user,
            ...rest,
            ...distractors,
          ]).where((word) => !used.contains(word.toLowerCase())).toList()
          ..shuffle(rng);
    final extra = leftover.take(words.length).toList();
    final options = [...words, ...extra]..shuffle(rng);
    return MemoryConfig(
      words: words,
      options: options,
      displaySeconds: displaySeconds,
      variant: variant,
      delaySeconds: delaySeconds.clamp(4, 20),
    );
  }

  final List<String> words;
  final List<String> options;
  final int displaySeconds;
  final MemoryVariant variant;
  final int delaySeconds;

  MemoryScore score(List<String> selected) {
    if (variant == MemoryVariant.order) {
      return scoreOrder(selected);
    }
    var hits = 0;
    var misses = 0;
    for (final word in selected) {
      if (words.contains(word)) {
        hits += 1;
      } else {
        misses += 1;
      }
    }
    for (final word in words) {
      if (!selected.contains(word)) {
        misses += 1;
      }
    }
    return MemoryScore(hits: hits, misses: misses, selected: selected);
  }

  MemoryScore scoreOrder(List<String> selected) {
    var hits = 0;
    var misses = 0;
    for (var i = 0; i < words.length; i++) {
      if (i < selected.length && selected[i] == words[i]) {
        hits += 1;
      } else {
        misses += 1;
      }
    }
    if (selected.length > words.length) {
      misses += selected.length - words.length;
    }
    return MemoryScore(hits: hits, misses: misses, selected: selected);
  }
}

class MemoryScore {
  const MemoryScore({
    required this.hits,
    required this.misses,
    required this.selected,
  });

  final int hits;
  final int misses;
  final List<String> selected;
}

const _fallbackIcons = [
  '🌙',
  '🌿',
  '☕',
  '📖',
  '🕯️',
  '🌊',
  '🪨',
  '🔔',
  '🫖',
  '🪷',
  '🪵',
  '⭐',
  '🍎',
  '🚲',
  '☂️',
  '🎹',
  '🔑',
  '🌸',
  '🧭',
  '🦋',
];

const _fallbackWords = [
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
  'luz',
  'vento',
  'folha',
  'trilha',
  'copo',
  'papel',
  'música',
  'estrela',
  'areia',
  'barco',
  'jardim',
  'chuva',
  'ponteiro',
  'caminho',
  'pedra',
  'ninho',
  'brisa',
];

List<String> _cleanWords(List<dynamic>? raw) {
  if (raw == null) {
    return const [];
  }
  return _uniqueWords(raw.map((item) => item.toString()));
}

List<String> _uniqueWords(Iterable<String> words) {
  final unique = <String>[];
  final seen = <String>{};
  for (final word in words) {
    final trimmed = word.trim();
    if (trimmed.isEmpty) {
      continue;
    }
    if (seen.add(trimmed.toLowerCase())) {
      unique.add(trimmed);
    }
  }
  return unique;
}

int _readInt(Object? value, int fallback) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value.trim()) ?? fallback;
  }
  return fallback;
}
