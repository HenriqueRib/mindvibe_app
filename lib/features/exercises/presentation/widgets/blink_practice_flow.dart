import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/blink_cycle.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/blink_exercise_view.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

/// Briefing → player → submit por set; opcionalmente sugere o próximo set do dia.
class BlinkPracticeFlow extends StatefulWidget {
  const BlinkPracticeFlow({
    super.key,
    required this.config,
    required this.onSubmitSet,
    this.briefingBody,
  });

  final BlinkCycleConfig config;
  final String? briefingBody;
  final Future<bool> Function({
    required int setIndex,
    required int durationMs,
    required bool hasMoreSets,
  })
  onSubmitSet;

  @override
  State<BlinkPracticeFlow> createState() => _BlinkPracticeFlowState();
}

class _BlinkPracticeFlowState extends State<BlinkPracticeFlow> {
  int _setIndex = 1;
  bool _started = false;
  bool _busy = false;
  int _runToken = 0;

  String get _variantKey => switch (widget.config.variant) {
    BlinkVariant.closeSqueezeOpen => 'close_squeeze_open',
    BlinkVariant.completeBlinks => 'complete_blinks',
    BlinkVariant.screenBreak20 => 'screen_break_20',
  };

  (String, String) _briefing(AppLocalizations l10n) {
    return switch (_variantKey) {
      'complete_blinks' => (
        l10n.blinkBriefingMicroTitle,
        l10n.blinkBriefingMicroBody,
      ),
      'screen_break_20' => (
        l10n.blinkBriefingBreakTitle,
        l10n.blinkBriefingBreakBody,
      ),
      _ => (l10n.blinkBriefingTitle, l10n.blinkBriefingBody),
    };
  }

  Future<void> _onCompleted(int durationMs) async {
    if (_busy) {
      return;
    }
    _busy = true;
    final hasMore = _setIndex < widget.config.setsPerDay;
    final ok = await widget.onSubmitSet(
      setIndex: _setIndex,
      durationMs: durationMs,
      hasMoreSets: hasMore,
    );
    if (!mounted) {
      return;
    }
    _busy = false;
    if (!ok) {
      return;
    }
    if (!hasMore) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final next = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.blinkSetDoneTitle(_setIndex, widget.config.setsPerDay),
          ),
          content: Text(
            l10n.blinkSetDoneBody(_setIndex + 1, widget.config.setsPerDay),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.blinkSetFinish),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.blinkSetContinue),
            ),
          ],
        );
      },
    );
    if (!mounted) {
      return;
    }
    if (next == true) {
      setState(() {
        _setIndex += 1;
        _runToken += 1;
      });
      return;
    }
    if (context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_started) {
      return BlinkExerciseView(
        key: ValueKey('blink-run-$_runToken-$_setIndex'),
        config: widget.config,
        setIndex: widget.config.hasMultipleSets ? _setIndex : null,
        setsPerDay: widget.config.hasMultipleSets
            ? widget.config.setsPerDay
            : null,
        onCompleted: _onCompleted,
      );
    }

    final (title, fallbackBody) = _briefing(l10n);
    final body = widget.briefingBody?.trim().isNotEmpty == true
        ? widget.briefingBody!
        : fallbackBody;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText.title(title, align: TextAlign.center),
                const SizedBox(height: 16),
                AppText.subtitle(body, align: TextAlign.center),
                if (widget.config.hasMultipleSets) ...[
                  const SizedBox(height: 24),
                  _SetPicker(
                    setsPerDay: widget.config.setsPerDay,
                    selected: _setIndex,
                    onChanged: (value) => setState(() => _setIndex = value),
                    label: l10n.blinkSetPickerLabel,
                    chipLabel: l10n.blinkSetChip,
                  ),
                ],
                if (widget.config.disclaimer) ...[
                  const SizedBox(height: 20),
                  Text(
                    l10n.blinkDisclaimer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: l10n.exerciseBriefingStart,
          onPressed: () => setState(() => _started = true),
        ),
      ],
    );
  }
}

class _SetPicker extends StatelessWidget {
  const _SetPicker({
    required this.setsPerDay,
    required this.selected,
    required this.onChanged,
    required this.label,
    required this.chipLabel,
  });

  final int setsPerDay;
  final int selected;
  final ValueChanged<int> onChanged;
  final String label;
  final String Function(int) chipLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            for (var i = 1; i <= setsPerDay; i++)
              ChoiceChip(
                label: Text(chipLabel(i)),
                selected: selected == i,
                onSelected: (_) => onChanged(i),
              ),
          ],
        ),
      ],
    );
  }
}
