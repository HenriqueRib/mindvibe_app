import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_motion.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/attention_shape.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/exercise_timer_bar.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class AttentionExerciseView extends StatefulWidget {
  const AttentionExerciseView({
    super.key,
    required this.config,
    required this.onCompleted,
    this.sessionSeconds,
  });

  final AttentionConfig config;
  final void Function(AttentionScore score) onCompleted;
  final int? sessionSeconds;

  @override
  State<AttentionExerciseView> createState() => _AttentionExerciseViewState();
}

class _AttentionExerciseViewState extends State<AttentionExerciseView> {
  late final AttentionEngine _engine;
  late final Random _random;
  late AttentionRound _round;
  AttentionSymbol? _previous;
  List<AttentionSymbol> _cells = const [];
  var _oddIndex = 0;
  var _gridTapped = -1;
  Timer? _roundTimer;
  Timer? _clock;
  final _startedAt = DateTime.now();
  bool _tapped = false;
  bool _finished = false;

  AttentionVariant get _variant => widget.config.variant;

  int get _sessionSeconds =>
      widget.sessionSeconds ?? widget.config.durationSeconds;

  Duration get _total => Duration(seconds: _sessionSeconds);

  Duration get _remaining {
    final left = _total - DateTime.now().difference(_startedAt);
    return left.isNegative ? Duration.zero : left;
  }

  int get _intervalMs {
    final start = widget.config.intervalMs <= 0
        ? (_variant == AttentionVariant.grid ? 2400 : 1500)
        : widget.config.intervalMs;
    final end = _variant == AttentionVariant.grid ? 1400 : 650;
    final t = (1 - _remaining.inMilliseconds / _total.inMilliseconds).clamp(
      0.0,
      1.0,
    );
    final curved = Curves.easeIn.transform(t);
    return (start + (end - start) * curved).round();
  }

  bool get _shouldTap {
    return switch (_variant) {
      AttentionVariant.target => _round.isTarget,
      AttentionVariant.nogo => !_round.isTarget,
      AttentionVariant.change =>
        _previous != null && _round.symbol != _previous,
      AttentionVariant.grid => false,
    };
  }

  @override
  void initState() {
    super.initState();
    _random = Random();
    _engine = AttentionEngine(widget.config);
    _round = _engine.nextRound();
    if (_variant == AttentionVariant.grid) {
      _nextGrid();
    }
    _scheduleRound();
    _clock = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted || _finished) {
        return;
      }
      setState(() {});
      if (_remaining <= Duration.zero) {
        _finish();
      }
    });
  }

  void _nextGrid() {
    final majority =
        AttentionSymbol.values[_random.nextInt(AttentionSymbol.values.length)];
    var odd = majority;
    while (odd == majority) {
      odd = AttentionSymbol
          .values[_random.nextInt(AttentionSymbol.values.length)];
    }
    _oddIndex = _random.nextInt(9);
    _cells = List<AttentionSymbol>.filled(9, majority);
    _cells[_oddIndex] = odd;
    _gridTapped = -1;
    _tapped = false;
  }

  void _scheduleRound() {
    _roundTimer?.cancel();
    _roundTimer = Timer(Duration(milliseconds: _intervalMs), _advance);
  }

  void _advance() {
    if (_finished) {
      return;
    }
    if (!_tapped) {
      if (_variant == AttentionVariant.target) {
        if (_round.isTarget) {
          _engine.registerMissedTarget();
        }
      } else if (_variant == AttentionVariant.grid) {
        _engine.registerMissedTarget();
      } else if (_shouldTap) {
        _engine.registerMissedTarget();
      } else {
        _engine.registerTap(isTarget: true);
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      if (_variant != AttentionVariant.grid) {
        _previous = _round.symbol;
        _tapped = false;
        _round = _engine.nextRound();
      } else {
        _nextGrid();
      }
    });
    _scheduleRound();
  }

  void _onTapShape() {
    if (_tapped || _finished) {
      return;
    }
    _tapped = true;
    if (_variant == AttentionVariant.target) {
      _engine.registerTap(isTarget: _round.isTarget);
    } else {
      _engine.registerTap(isTarget: _shouldTap);
    }
    setState(() {});
  }

  void _onTapCell(int index) {
    if (_tapped || _finished) {
      return;
    }
    _tapped = true;
    _gridTapped = index;
    _engine.registerTap(isTarget: index == _oddIndex);
    setState(() {});
  }

  void _finish() {
    if (_finished) {
      return;
    }
    _finished = true;
    _roundTimer?.cancel();
    _clock?.cancel();
    widget.onCompleted(
      _engine.score(DateTime.now().difference(_startedAt).inMilliseconds),
    );
  }

  @override
  void dispose() {
    _roundTimer?.cancel();
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExerciseTimerBar(remaining: _remaining, total: _total),
        const SizedBox(height: 16),
        Text(
          _prompt(l10n),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 8),
        if (_variant == AttentionVariant.target ||
            _variant == AttentionVariant.nogo)
          Center(child: AttentionShape(symbol: widget.config.target, size: 36)),
        if (_variant == AttentionVariant.change && _previous != null) ...[
          Text(
            l10n.attentionPreviousLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Center(child: AttentionShape(symbol: _previous!, size: 28)),
        ],
        const Spacer(),
        if (_variant == AttentionVariant.grid)
          _grid()
        else
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: fadeScaleSwitcher,
            child: AttentionShape(
              key: ValueKey('${_round.symbol}-$_tapped'),
              symbol: _round.symbol,
              size: 128,
              color: _tapped
                  ? (_shouldTap ||
                            (_variant == AttentionVariant.target &&
                                _round.isTarget)
                        ? AppColors.success
                        : AppColors.error)
                  : attentionSymbolColor(_round.symbol),
              onTap: _onTapShape,
            ),
          ),
        const Spacer(),
        Text(
          l10n.attentionHits(_engine.hits),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        Text(
          l10n.attentionMisses(_engine.misses),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }

  String _prompt(AppLocalizations l10n) {
    return switch (_variant) {
      AttentionVariant.target => l10n.attentionTargetLabel,
      AttentionVariant.nogo => l10n.attentionNogoLabel,
      AttentionVariant.change => l10n.attentionChangeLabel,
      AttentionVariant.grid => l10n.attentionGridLabel,
    };
  }

  Widget _grid() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final tapped = _gridTapped == index;
              final correct = index == _oddIndex;
              return LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest.shortestSide;
                  return Center(
                    child: AttentionShape(
                      key: ValueKey('$index-${_cells[index]}-$_gridTapped'),
                      symbol: _cells[index],
                      size: size,
                      color: tapped
                          ? (correct ? AppColors.success : AppColors.error)
                          : attentionSymbolColor(_cells[index]),
                      onTap: () => _onTapCell(index),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
