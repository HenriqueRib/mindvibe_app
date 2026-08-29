import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/exercise_timer_bar.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

enum _MemoryPhase { study, hold, select }

class MemoryExerciseView extends StatefulWidget {
  const MemoryExerciseView({
    super.key,
    required this.config,
    required this.onCompleted,
    this.sessionSeconds,
  });

  final MemoryConfig config;
  final void Function(MemoryScore score) onCompleted;
  final int? sessionSeconds;

  @override
  State<MemoryExerciseView> createState() => _MemoryExerciseViewState();
}

class _MemoryExerciseViewState extends State<MemoryExerciseView> {
  late final MemoryConfig _config = widget.config;
  late _MemoryPhase _phase = _MemoryPhase.study;
  final _selected = <String>{};
  final _sequence = <String>[];
  var _orderIndex = 0;
  Timer? _stepTimer;
  final _startedAt = DateTime.now();
  bool _finished = false;

  MemoryVariant get _variant => _config.variant;

  bool get _icons => _variant == MemoryVariant.icons;

  int get _studySeconds {
    if (_variant == MemoryVariant.order) {
      return _config.displaySeconds;
    }
    final display = _config.displaySeconds;
    final session = widget.sessionSeconds;
    if (session == null) {
      return display;
    }
    final cap = session < 12 ? session ~/ 2 : session ~/ 4;
    if (cap < 3) {
      return display > session ? session : display;
    }
    return display > cap ? cap : display;
  }

  int get _holdSeconds {
    final delay = _config.delaySeconds;
    final session = widget.sessionSeconds;
    if (session == null) {
      return delay;
    }
    final left = session - DateTime.now().difference(_startedAt).inSeconds;
    if (left <= 6) {
      return 3;
    }
    return delay > left - 8 ? (left - 8).clamp(3, delay) : delay;
  }

  Duration get _total {
    final seconds = widget.sessionSeconds;
    if (seconds != null) {
      return Duration(seconds: seconds);
    }
    if (_variant == MemoryVariant.delayed) {
      return Duration(
        seconds: _config.displaySeconds + _config.delaySeconds + 20,
      );
    }
    if (_variant == MemoryVariant.order) {
      return Duration(
        seconds: _config.displaySeconds * _config.words.length + 30,
      );
    }
    return Duration(seconds: _config.displaySeconds);
  }

  @override
  void initState() {
    super.initState();
    _scheduleStudy();
  }

  void _onTimeUp() {
    if (!mounted || _finished) {
      return;
    }
    if (_phase != _MemoryPhase.select) {
      setState(() => _phase = _MemoryPhase.select);
      return;
    }
    _finish();
  }

  void _scheduleStudy() {
    _stepTimer?.cancel();
    _stepTimer = Timer(Duration(seconds: _studySeconds), _onStudyTick);
  }

  void _onStudyTick() {
    if (!mounted || _finished) {
      return;
    }
    if (_variant == MemoryVariant.order) {
      if (_orderIndex < _config.words.length - 1) {
        setState(() => _orderIndex += 1);
        _scheduleStudy();
        return;
      }
      setState(() => _phase = _MemoryPhase.select);
      return;
    }
    if (_variant == MemoryVariant.delayed) {
      setState(() => _phase = _MemoryPhase.hold);
      _stepTimer = Timer(Duration(seconds: _holdSeconds), () {
        if (mounted && !_finished) {
          setState(() => _phase = _MemoryPhase.select);
        }
      });
      return;
    }
    setState(() => _phase = _MemoryPhase.select);
  }

  void _finish() {
    if (_finished) {
      return;
    }
    _finished = true;
    _stepTimer?.cancel();
    final picked = _variant == MemoryVariant.order
        ? _sequence
        : _selected.toList();
    widget.onCompleted(_config.score(picked));
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: switch (_phase) {
        _MemoryPhase.study => _study(l10n),
        _MemoryPhase.hold => _hold(l10n),
        _MemoryPhase.select =>
          _variant == MemoryVariant.order ? _orderSelect(l10n) : _select(l10n),
      },
    );
  }

  Widget _study(AppLocalizations l10n) {
    final title = switch (_variant) {
      MemoryVariant.icons => l10n.memoryStudyIconsTitle,
      MemoryVariant.order => l10n.memoryOrderStudyTitle,
      _ => l10n.memoryStudyTitle,
    };
    return Column(
      key: ValueKey('study-$_orderIndex'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LiveTimerBar(
          startedAt: _startedAt,
          total: _total,
          onExpired: _onTimeUp,
        ),
        const SizedBox(height: 20),
        FadeSlideIn(child: AppText.title(title, align: TextAlign.center)),
        const SizedBox(height: 24),
        if (_variant == MemoryVariant.order)
          Expanded(
            child: Center(
              child: FadeSlideIn(
                child: _itemCard(_config.words[_orderIndex], large: true),
              ),
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var i = 0; i < _config.words.length; i++)
                    FadeSlideIn(index: i, child: _itemCard(_config.words[i])),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _hold(AppLocalizations l10n) {
    return Column(
      key: const ValueKey('hold'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LiveTimerBar(
          startedAt: _startedAt,
          total: _total,
          onExpired: _onTimeUp,
        ),
        const Spacer(),
        FadeSlideIn(
          child: AppText.title(l10n.memoryHoldTitle, align: TextAlign.center),
        ),
        const SizedBox(height: 12),
        FadeSlideIn(
          child: AppText.subtitle(l10n.memoryHoldBody, align: TextAlign.center),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _select(AppLocalizations l10n) {
    final title = _icons ? l10n.memorySelectIconsTitle : l10n.memorySelectTitle;
    return Column(
      key: const ValueKey('select'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LiveTimerBar(
          startedAt: _startedAt,
          total: _total,
          onExpired: _onTimeUp,
        ),
        const SizedBox(height: 16),
        FadeSlideIn(child: AppText.title(title, align: TextAlign.center)),
        const SizedBox(height: 16),
        Expanded(
          child: _icons
              ? SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var i = 0; i < _config.options.length; i++)
                        FadeSlideIn(
                          index: i,
                          child: _choiceChip(_config.options[i]),
                        ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    for (var i = 0; i < _config.options.length; i++)
                      FadeSlideIn(
                        index: i,
                        child: CheckboxListTile(
                          value: _selected.contains(_config.options[i]),
                          title: Text(_config.options[i]),
                          onChanged: (checked) {
                            setState(() {
                              final word = _config.options[i];
                              if (checked ?? false) {
                                _selected.add(word);
                              } else {
                                _selected.remove(word);
                              }
                            });
                          },
                        ),
                      ),
                  ],
                ),
        ),
        AppButton(label: l10n.actionContinue, onPressed: _finish),
      ],
    );
  }

  Widget _orderSelect(AppLocalizations l10n) {
    return Column(
      key: const ValueKey('order'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LiveTimerBar(
          startedAt: _startedAt,
          total: _total,
          onExpired: _onTimeUp,
        ),
        const SizedBox(height: 16),
        FadeSlideIn(
          child: AppText.title(
            l10n.memoryOrderSelectTitle,
            align: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        if (_sequence.isNotEmpty)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _sequence.length; i++)
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  label: Text(_sequence[i]),
                ),
            ],
          ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final option in _config.options)
                  _choiceChip(
                    option,
                    selected: _sequence.contains(option),
                    onTap: _sequence.contains(option)
                        ? null
                        : () => setState(() => _sequence.add(option)),
                  ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: l10n.memoryOrderReset,
                variant: AppButtonVariant.secondary,
                onPressed: () => setState(_sequence.clear),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(label: l10n.actionContinue, onPressed: _finish),
            ),
          ],
        ),
      ],
    );
  }

  Widget _choiceChip(String value, {bool? selected, VoidCallback? onTap}) {
    final on = selected ?? _selected.contains(value);
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap:
          onTap ??
          () {
            setState(() {
              if (on) {
                _selected.remove(value);
              } else {
                _selected.add(value);
              }
            });
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: _icons ? 14 : 16,
          vertical: _icons ? 12 : 10,
        ),
        decoration: BoxDecoration(
          color: on
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.28)
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: on ? Theme.of(context).colorScheme.primary : scheme.outline,
            width: on ? 2 : 1,
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: _icons ? 32 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _itemCard(String value, {bool large = false}) {
    final muted = Theme.of(context).colorScheme.surfaceContainerHighest;
    if (_icons || large) {
      return Container(
        padding: EdgeInsets.all(large ? 28 : 16),
        decoration: BoxDecoration(
          color: muted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: large ? 56 : (_icons ? 36 : 22),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Chip(label: Text(value), backgroundColor: muted);
  }
}

class _LiveTimerBar extends StatefulWidget {
  const _LiveTimerBar({
    required this.startedAt,
    required this.total,
    required this.onExpired,
  });

  final DateTime startedAt;
  final Duration total;
  final VoidCallback onExpired;

  @override
  State<_LiveTimerBar> createState() => _LiveTimerBarState();
}

class _LiveTimerBarState extends State<_LiveTimerBar> {
  Timer? _timer;
  var _expired = false;

  Duration get _remaining {
    final left = widget.total - DateTime.now().difference(widget.startedAt);
    return left.isNegative ? Duration.zero : left;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      if (!_expired && _remaining <= Duration.zero) {
        _expired = true;
        widget.onExpired();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExerciseTimerBar(remaining: _remaining, total: widget.total);
  }
}
