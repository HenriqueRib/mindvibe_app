import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';

void main() {
  test('rating lê min, max e prompt da configuração', () {
    final config = RatingConfig.fromJson({
      'min': 1,
      'max': 5,
      'prompt': 'Como está seu foco?',
      'labels': {'1': 'baixo', '5': 'alto'},
    });
    expect(config.min, 1);
    expect(config.max, 5);
    expect(config.prompt, 'Como está seu foco?');
    expect(config.labels[5], 'alto');
  });

  test('attention usa alvo triangle e gera rodadas', () {
    final engine = AttentionEngine(
      AttentionConfig.fromJson({
        'duration_seconds': 30,
        'target': 'triangle',
        'sequence': ['circle', 'triangle', 'square'],
      }),
      random: (max) => 0,
    );
    final first = engine.nextRound();
    expect(first.symbol, AttentionSymbol.circle);
    expect(first.isTarget, isFalse);
    engine.registerTap(isTarget: false);
    expect(engine.misses, 1);
    final second = engine.nextRound();
    expect(second.isTarget, isTrue);
    engine.registerTap(isTarget: true);
    expect(engine.hits, 1);
  });

  test('memory pontua acertos e erros', () {
    const config = MemoryConfig(
      words: ['casa', 'mesa', 'livro'],
      options: ['casa', 'mesa', 'livro', 'sol', 'rio'],
      displaySeconds: 8,
    );
    final score = config.score(['casa', 'sol']);
    expect(score.hits, 1);
    expect(score.misses, 3);
  });

  test('memory lê word_count mesmo quando vem como texto', () {
    final config = MemoryConfig.fromJson({
      'word_count': '4',
      'display_seconds': '8',
      'words': ['casa', 'mesa', 'livro', 'água'],
    }, random: Random(1));
    expect(config.words.length, 4);
    expect(config.displaySeconds, 8);
  });
}
