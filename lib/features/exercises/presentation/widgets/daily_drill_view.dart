import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/daily_drills.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/timer_ring.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class DailyDrillView extends StatefulWidget {
  const DailyDrillView({
    super.key,
    required this.exercise,
    required this.onCompleted,
    this.durationOverride,
  });

  final ExerciseSpec exercise;
  final void Function(Map<String, dynamic> payload) onCompleted;
  final int? durationOverride;

  @override
  State<DailyDrillView> createState() => _DailyDrillViewState();
}

class _DailyDrillViewState extends State<DailyDrillView> {
  final _startedAt = Stopwatch()..start();

  DailyVariant get _variant => dailyVariantFrom(widget.exercise.variant);

  int get _seconds => widget.durationOverride ?? dailyDefaultSeconds(_variant);

  void _finish({int filled = 0, int correct = 0}) {
    widget.onCompleted({
      'completed': true,
      'duration_ms': _startedAt.elapsedMilliseconds,
      'filled_count': filled,
      'correct': correct,
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_variant) {
      DailyVariant.observe => _ObserveDrill(
        seconds: _seconds,
        onDone: () => _finish(filled: 1),
      ),
      DailyVariant.reverse => _ReverseDrill(onDone: _finish),
      DailyVariant.categories => _CategoriesDrill(
        seconds: _seconds,
        onDone: (filled) => _finish(filled: filled),
      ),
      DailyVariant.retell => _RetellDrill(
        onDone: (filled) => _finish(filled: filled),
      ),
      DailyVariant.countdown => _CountdownDrill(
        onDone: (correct) => _finish(correct: correct),
      ),
      DailyVariant.senses => _SensesDrill(
        onDone: (filled) => _finish(filled: filled),
      ),
      DailyVariant.singleTask => _SingleTaskDrill(
        seconds: _seconds,
        onDone: () => _finish(filled: 1),
      ),
      DailyVariant.uses => _UsesDrill(
        seconds: _seconds,
        onDone: (filled) => _finish(filled: filled),
      ),
      DailyVariant.sort => _SortDrill(
        onDone: (filled) => _finish(filled: filled),
      ),
      DailyVariant.silence => _SilenceDrill(
        seconds: _seconds,
        onDone: () => _finish(filled: 1),
      ),
    };
  }
}

class _ObserveDrill extends StatefulWidget {
  const _ObserveDrill({required this.seconds, required this.onDone});

  final int seconds;
  final VoidCallback onDone;

  @override
  State<_ObserveDrill> createState() => _ObserveDrillState();
}

class _ObserveDrillState extends State<_ObserveDrill> {
  String? _object;
  var _left = 0;
  var _prompt = 0;
  Timer? _timer;

  void _pick(String object) {
    setState(() {
      _object = object;
      _left = widget.seconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      if (_left <= 1) {
        _timer?.cancel();
        widget.onDone();
        return;
      }
      setState(() {
        _left -= 1;
        if ((widget.seconds - _left) % 30 == 0) {
          _prompt = (_prompt + 1) % dailyObservePrompts.length;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_object == null) {
      return ListView(
        children: [
          AppText.subtitle(l10n.dailyObservePick, align: TextAlign.center),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final object in dailyObserveObjects)
                ActionChip(label: Text(object), onPressed: () => _pick(object)),
            ],
          ),
        ],
      );
    }
    return Column(
      children: [
        Text(
          l10n.dailyObserveLook(_object!),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          dailyObservePrompts[_prompt],
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, fontSize: 18),
        ),
        const Spacer(),
        _RingClock(left: _left, total: widget.seconds),
        const Spacer(),
        AppButton(label: l10n.dailyFinish, onPressed: widget.onDone),
      ],
    );
  }
}

class _ReverseDrill extends StatefulWidget {
  const _ReverseDrill({required this.onDone});

  final void Function({int filled, int correct}) onDone;

  @override
  State<_ReverseDrill> createState() => _ReverseDrillState();
}

class _ReverseDrillState extends State<_ReverseDrill> {
  late final ReverseRound _round = randomReverseRound();
  late final List<String> _options = _round.shuffledOptions();
  var _showing = true;
  var _index = 0;
  var _correct = 0;
  String? _wrong;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showing = false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tap(String item) {
    final expected = _round.expected[_index];
    HapticFeedback.selectionClick();
    if (item != expected) {
      setState(() => _wrong = item);
      return;
    }
    setState(() {
      _wrong = null;
      _correct += 1;
      _index += 1;
    });
    if (_index >= _round.expected.length) {
      widget.onDone(filled: 5, correct: _correct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_showing) {
      return Column(
        children: [
          AppText.subtitle(l10n.dailyReverseLook, align: TextAlign.center),
          const Spacer(),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (final item in _round.items)
                _Token(label: item, selected: true),
            ],
          ),
          const Spacer(),
          AppButton(
            label: l10n.dailyReady,
            onPressed: () {
              _timer?.cancel();
              setState(() => _showing = false);
            },
          ),
        ],
      );
    }
    return Column(
      children: [
        AppText.subtitle(l10n.dailyReverseAsk, align: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          l10n.dailyReverseStep(_index + 1, _round.expected.length),
          style: const TextStyle(color: AppColors.muted),
        ),
        const Spacer(),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            for (final item in _options)
              _Token(
                label: item,
                error: _wrong == item,
                done: _round.expected.take(_index).contains(item),
                onTap: _round.expected.take(_index).contains(item)
                    ? null
                    : () => _tap(item),
              ),
          ],
        ),
        if (_wrong != null) ...[
          const SizedBox(height: 16),
          Text(
            l10n.dailyReverseWrong,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error),
          ),
        ],
        const Spacer(),
      ],
    );
  }
}

class _CategoriesDrill extends StatefulWidget {
  const _CategoriesDrill({required this.seconds, required this.onDone});

  final int seconds;
  final void Function(int filled) onDone;

  @override
  State<_CategoriesDrill> createState() => _CategoriesDrillState();
}

class _CategoriesDrillState extends State<_CategoriesDrill> {
  late final String _letter = randomPick(dailyCategoryLetters);
  final _lists = List.generate(4, (_) => <String>[]);
  final _input = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  var _left = 0;
  var _group = 0;

  @override
  void initState() {
    super.initState();
    _left = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      if (_left <= 1) {
        _timer?.cancel();
        _tryFinish();
        return;
      }
      setState(() => _left -= 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  int get _filled => _lists.fold(0, (sum, list) => sum + list.length);

  bool get _canFinish =>
      dailyCanComplete(variant: DailyVariant.categories, filled: _filled);

  void _tryFinish() {
    if (!_canFinish) {
      if (mounted) {
        setState(() => _left = 0);
      }
      return;
    }
    widget.onDone(_filled);
  }

  void _refocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focus.requestFocus();
      }
    });
  }

  void _add() {
    final value = _input.text.trim();
    if (!isDailyTypedAnswer(value)) {
      return;
    }
    _input.clear();
    HapticFeedback.selectionClick();
    setState(() {
      _lists[_group].add(value);
      if (_lists[_group].length >= 5 && _group < 3) {
        _group += 1;
      }
    });
    _refocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = dailyCategoryNames[_group];
    final full = _lists[_group].length >= 5;
    final last = _group >= 3;
    return ListView(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      children: [
        Text(
          l10n.dailyCategoriesLetter(_letter),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.dailyTimerLeft(_left),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 16),
        Text(
          '$current · ${_lists[_group].length}/5',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < _lists[_group].length; i++)
              _Token(
                label: _lists[_group][i],
                selected: true,
                onTap: () {
                  setState(() => _lists[_group].removeAt(i));
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (!full)
          TextField(
            controller: _input,
            focusNode: _focus,
            autofocus: true,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => _add(),
            decoration: InputDecoration(hintText: '$_letter…'),
          ),
        const SizedBox(height: 12),
        AppButton(
          label: full
              ? (last ? l10n.dailyFinish : l10n.actionContinue)
              : l10n.dailyAdd,
          onPressed: full
              ? () {
                  if (last) {
                    _tryFinish();
                    return;
                  }
                  setState(() => _group += 1);
                  _refocus();
                }
              : _add,
        ),
        if (!last) ...[
          const SizedBox(height: 8),
          AppButton(
            label: l10n.dailySkipThis,
            variant: AppButtonVariant.ghost,
            onPressed: () {
              setState(() => _group += 1);
              _refocus();
            },
          ),
        ],
        const SizedBox(height: 8),
        _FinishGate(
          canFinish: _canFinish,
          hint: l10n.dailyNeedWrite,
          onFinish: _tryFinish,
        ),
      ],
    );
  }
}

class _RetellDrill extends StatefulWidget {
  const _RetellDrill({required this.onDone});

  final void Function(int filled) onDone;

  @override
  State<_RetellDrill> createState() => _RetellDrillState();
}

class _RetellDrillState extends State<_RetellDrill> {
  late final String _text = randomPick(dailyRetellTexts);
  var _reading = true;
  final _retell = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 40), () {
      if (mounted) {
        setState(() => _reading = false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _retell.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_reading) {
      return Column(
        children: [
          AppText.subtitle(l10n.dailyRetellRead, align: TextAlign.center),
          const Spacer(),
          Text(
            _text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, height: 1.45),
          ),
          const Spacer(),
          AppButton(
            label: l10n.dailyRetellHide,
            onPressed: () {
              _timer?.cancel();
              setState(() => _reading = false);
            },
          ),
        ],
      );
    }
    return ListView(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      children: [
        AppText.subtitle(l10n.dailyRetellWrite, align: TextAlign.center),
        const SizedBox(height: 16),
        TextField(
          controller: _retell,
          minLines: 5,
          maxLines: 8,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: l10n.dailyRetellHint),
        ),
        const SizedBox(height: 20),
        _FinishGate(
          canFinish: dailyCanComplete(
            variant: DailyVariant.retell,
            filled: dailyRetellFilled(_retell.text),
          ),
          hint: l10n.dailyNeedWrite,
          primary: true,
          onFinish: () => widget.onDone(1),
        ),
      ],
    );
  }
}

class _CountdownDrill extends StatefulWidget {
  const _CountdownDrill({required this.onDone});

  final void Function(int correct) onDone;

  @override
  State<_CountdownDrill> createState() => _CountdownDrillState();
}

class _CountdownDrillState extends State<_CountdownDrill> {
  var _current = 100;
  var _correct = 0;
  var _error = false;
  late List<int> _choices = countdownChoices(100);

  void _pick(int value) {
    final expected = _current - 3;
    HapticFeedback.selectionClick();
    if (value != expected) {
      setState(() => _error = true);
      return;
    }
    if (expected <= 0) {
      widget.onDone(_correct + 1);
      return;
    }
    setState(() {
      _error = false;
      _current = expected;
      _correct += 1;
      _choices = countdownChoices(expected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        AppText.subtitle(l10n.dailyCountdownAsk, align: TextAlign.center),
        const Spacer(),
        Text(
          '$_current',
          style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.dailyCountdownMinus,
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LinearProgressIndicator(
            value: (100 - _current) / 100,
            minHeight: 6,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.primary,
            backgroundColor: AppColors.surfaceMuted,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            for (final choice in _choices)
              _Token(
                label: '$choice',
                error: _error && choice != _current - 3,
                onTap: () => _pick(choice),
              ),
          ],
        ),
        if (_error) ...[
          const SizedBox(height: 16),
          Text(
            l10n.dailyCountdownWrong,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error),
          ),
        ],
        const Spacer(),
        _FinishGate(
          canFinish: dailyCanComplete(
            variant: DailyVariant.countdown,
            correct: _correct,
          ),
          hint: l10n.dailyNeedCount,
          onFinish: () => widget.onDone(_correct),
        ),
      ],
    );
  }
}

class _SensesDrill extends StatefulWidget {
  const _SensesDrill({required this.onDone});

  final void Function(int filled) onDone;

  @override
  State<_SensesDrill> createState() => _SensesDrillState();
}

class _SensesDrillState extends State<_SensesDrill> {
  final _input = TextEditingController();
  final _focus = FocusNode();
  final _lists = List.generate(5, (_) => <String>[]);
  var _group = 0;

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  int get _filled => _lists.fold(0, (sum, list) => sum + list.length);

  bool get _canFinish =>
      dailyCanComplete(variant: DailyVariant.senses, filled: _filled);

  void _tryFinish() {
    if (!_canFinish) {
      return;
    }
    widget.onDone(_filled);
  }

  void _refocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focus.requestFocus();
      }
    });
  }

  void _add(List<(String, int)> groups) {
    final value = _input.text.trim();
    if (!isDailyTypedAnswer(value)) {
      return;
    }
    _input.clear();
    HapticFeedback.selectionClick();
    setState(() {
      _lists[_group].add(value);
      if (_lists[_group].length >= groups[_group].$2 && _group < 4) {
        _group += 1;
      }
    });
    _refocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groups = [
      (l10n.dailySensesSee, 5),
      (l10n.dailySensesTouch, 4),
      (l10n.dailySensesHear, 3),
      (l10n.dailySensesSmell, 2),
      (l10n.dailySensesFeel, 1),
    ];
    final current = groups[_group];
    final full = _lists[_group].length >= current.$2;
    final last = _group >= 4;
    final done = full && last;
    return ListView(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      children: [
        AppText.subtitle(l10n.dailySensesHint, align: TextAlign.center),
        const SizedBox(height: 16),
        Text(
          '${current.$1} · ${_lists[_group].length}/${current.$2}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < _lists[_group].length; i++)
              _Token(
                label: _lists[_group][i],
                selected: true,
                onTap: () => setState(() => _lists[_group].removeAt(i)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (!full)
          TextField(
            controller: _input,
            focusNode: _focus,
            autofocus: true,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => _add(groups),
          ),
        const SizedBox(height: 12),
        AppButton(
          label: done
              ? l10n.dailyFinish
              : full
              ? l10n.actionContinue
              : l10n.dailyAdd,
          onPressed: done
              ? (_canFinish ? _tryFinish : null)
              : full
              ? () {
                  setState(() => _group += 1);
                  _refocus();
                }
              : () => _add(groups),
        ),
        if (!last) ...[
          const SizedBox(height: 8),
          AppButton(
            label: l10n.dailySkipThis,
            variant: AppButtonVariant.ghost,
            onPressed: () {
              setState(() => _group += 1);
              _refocus();
            },
          ),
        ],
        const SizedBox(height: 8),
        _FinishGate(
          canFinish: _canFinish,
          hint: l10n.dailyNeedWrite,
          onFinish: _tryFinish,
        ),
      ],
    );
  }
}

class _SingleTaskDrill extends StatefulWidget {
  const _SingleTaskDrill({required this.seconds, required this.onDone});

  final int seconds;
  final VoidCallback onDone;

  @override
  State<_SingleTaskDrill> createState() => _SingleTaskDrillState();
}

class _SingleTaskDrillState extends State<_SingleTaskDrill> {
  String? _task;
  var _left = 0;
  Timer? _timer;

  void _start(String task) {
    setState(() {
      _task = task;
      _left = widget.seconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      if (_left <= 1) {
        _timer?.cancel();
        widget.onDone();
        return;
      }
      setState(() => _left -= 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_task == null) {
      return ListView(
        children: [
          AppText.subtitle(l10n.dailyTaskPick, align: TextAlign.center),
          const SizedBox(height: 16),
          for (final task in dailySingleTasks) ...[
            AppCard(
              onTap: () => _start(task),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                task,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      );
    }
    return Column(
      children: [
        Text(
          l10n.dailyTaskDoing(_task!),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        AppText.subtitle(l10n.dailyTaskPhone, align: TextAlign.center),
        const Spacer(),
        _RingClock(left: _left, total: widget.seconds),
        const Spacer(),
        AppButton(label: l10n.dailyFinish, onPressed: widget.onDone),
      ],
    );
  }
}

class _UsesDrill extends StatefulWidget {
  const _UsesDrill({required this.seconds, required this.onDone});

  final int seconds;
  final void Function(int filled) onDone;

  @override
  State<_UsesDrill> createState() => _UsesDrillState();
}

class _UsesDrillState extends State<_UsesDrill> {
  late final String _object = randomPick(dailyUseObjects);
  final _items = <String>[];
  final _input = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  var _left = 0;

  @override
  void initState() {
    super.initState();
    _left = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      if (_left <= 1) {
        _timer?.cancel();
        _tryFinish();
        return;
      }
      setState(() => _left -= 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _canFinish =>
      dailyCanComplete(variant: DailyVariant.uses, filled: _items.length);

  void _tryFinish() {
    if (!_canFinish) {
      if (mounted) {
        setState(() => _left = 0);
      }
      return;
    }
    widget.onDone(_items.length);
  }

  void _add() {
    final value = _input.text.trim();
    if (!isDailyTypedAnswer(value) || _items.length >= 10) {
      return;
    }
    _input.clear();
    HapticFeedback.selectionClick();
    setState(() => _items.add(value));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      children: [
        Text(
          l10n.dailyUsesObject(_object),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          '${_items.length}/10 · ${l10n.dailyTimerLeft(_left)}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < _items.length; i++)
              _Token(
                label: _items[i],
                selected: true,
                onTap: () => setState(() => _items.removeAt(i)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_items.length < 10)
          TextField(
            controller: _input,
            focusNode: _focus,
            autofocus: true,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => _add(),
            decoration: InputDecoration(hintText: '${_items.length + 1}'),
          ),
        const SizedBox(height: 12),
        AppButton(
          label: _items.length < 10 ? l10n.dailyAdd : l10n.dailyFinish,
          onPressed: _items.length < 10 ? _add : _tryFinish,
        ),
        if (_items.length < 10) ...[
          const SizedBox(height: 8),
          _FinishGate(
            canFinish: _canFinish,
            hint: l10n.dailyNeedWrite,
            onFinish: _tryFinish,
          ),
        ],
      ],
    );
  }
}

enum _SortBucket { resolve, later, notMine }

class _SortDrill extends StatefulWidget {
  const _SortDrill({required this.onDone});

  final void Function(int filled) onDone;

  @override
  State<_SortDrill> createState() => _SortDrillState();
}

class _SortDrillState extends State<_SortDrill> {
  final _dump = TextEditingController();
  var _phase = 0;
  var _index = 0;
  var _needWrite = false;
  final _items = <String>[];
  final _buckets = <int, _SortBucket>{};

  @override
  void dispose() {
    _dump.dispose();
    super.dispose();
  }

  void _split() {
    final lines = _dump.text
        .split(RegExp(r'[\n,]'))
        .map((line) => line.trim())
        .where(isDailyTypedAnswer)
        .take(8)
        .toList();
    if (!dailyCanComplete(variant: DailyVariant.sort, filled: lines.length)) {
      setState(() => _needWrite = true);
      return;
    }
    setState(() {
      _items
        ..clear()
        ..addAll(lines);
      _index = 0;
      _phase = 1;
    });
  }

  void _classify(_SortBucket bucket) {
    HapticFeedback.selectionClick();
    _buckets[_index] = bucket;
    if (_index >= _items.length - 1) {
      widget.onDone(_items.length);
      return;
    }
    setState(() => _index += 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_phase == 0) {
      return ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        children: [
          AppText.subtitle(l10n.dailySortDump, align: TextAlign.center),
          const SizedBox(height: 16),
          TextField(
            controller: _dump,
            minLines: 6,
            maxLines: 10,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) {
              if (_needWrite) {
                setState(() => _needWrite = false);
              }
            },
            decoration: InputDecoration(hintText: l10n.dailySortHint),
          ),
          const SizedBox(height: 20),
          AppButton(label: l10n.dailySortClassify, onPressed: _split),
          if (_needWrite) ...[
            const SizedBox(height: 12),
            Text(
              l10n.dailyNeedWrite,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ],
        ],
      );
    }
    return Column(
      children: [
        Text(
          l10n.dailyCircuitStep(_index + 1, _items.length),
          style: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        AppText.subtitle(l10n.dailySortPick, align: TextAlign.center),
        const Spacer(),
        Text(
          _items[_index],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
        const Spacer(),
        AppButton(
          label: l10n.dailySortResolve,
          onPressed: () => _classify(_SortBucket.resolve),
        ),
        const SizedBox(height: 8),
        AppButton(
          label: l10n.dailySortLater,
          variant: AppButtonVariant.secondary,
          onPressed: () => _classify(_SortBucket.later),
        ),
        const SizedBox(height: 8),
        AppButton(
          label: l10n.dailySortNotMine,
          variant: AppButtonVariant.ghost,
          onPressed: () => _classify(_SortBucket.notMine),
        ),
      ],
    );
  }
}

class _SilenceDrill extends StatefulWidget {
  const _SilenceDrill({required this.seconds, required this.onDone});

  final int seconds;
  final VoidCallback onDone;

  @override
  State<_SilenceDrill> createState() => _SilenceDrillState();
}

class _SilenceDrillState extends State<_SilenceDrill> {
  var _running = false;
  var _left = 0;
  Timer? _timer;

  void _start() {
    setState(() {
      _running = true;
      _left = widget.seconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      if (_left <= 1) {
        _timer?.cancel();
        widget.onDone();
        return;
      }
      setState(() => _left -= 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_running) {
      return Column(
        children: [
          const Spacer(),
          AppText.subtitle(l10n.dailySilenceHint, align: TextAlign.center),
          const Spacer(),
          AppButton(label: l10n.dailyStart, onPressed: _start),
        ],
      );
    }
    return Column(
      children: [
        AppText.subtitle(l10n.dailySilenceHint, align: TextAlign.center),
        const Spacer(),
        _RingClock(left: _left, total: widget.seconds),
        const Spacer(),
        AppButton(label: l10n.dailyFinish, onPressed: widget.onDone),
      ],
    );
  }
}

class _FinishGate extends StatelessWidget {
  const _FinishGate({
    required this.canFinish,
    required this.hint,
    required this.onFinish,
    this.primary = false,
  });

  final bool canFinish;
  final String hint;
  final VoidCallback onFinish;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: AppLocalizations.of(context).dailyFinish,
          variant: primary ? AppButtonVariant.primary : AppButtonVariant.ghost,
          onPressed: canFinish ? onFinish : null,
        ),
        if (!canFinish) ...[
          const SizedBox(height: 10),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              height: 1.4,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}

class _Token extends StatelessWidget {
  const _Token({
    required this.label,
    this.selected = false,
    this.done = false,
    this.error = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final bool done;
  final bool error;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = error
        ? AppColors.error
        : done
        ? AppColors.success
        : selected
        ? AppColors.primary
        : AppColors.border;
    final fill = error
        ? AppColors.error.withValues(alpha: 0.14)
        : done
        ? AppColors.success.withValues(alpha: 0.16)
        : selected
        ? AppColors.primary.withValues(alpha: 0.12)
        : AppColors.surfaceMuted;
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: label.length <= 2 ? 28 : 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    if (onTap == null) {
      return child;
    }
    return GestureDetector(onTap: onTap, child: child);
  }
}

class _RingClock extends StatelessWidget {
  const _RingClock({required this.left, required this.total});

  final int left;
  final int total;

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    final minutes = (left ~/ 60).toString().padLeft(2, '0');
    final seconds = (left % 60).toString().padLeft(2, '0');
    return TimerRing(
      progress: total <= 0 ? 1 : 1 - (left / total),
      color: AppColors.primary,
      track: night ? AppColors.nightSurface : AppColors.surfaceMuted,
      child: Text(
        '$minutes:$seconds',
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
