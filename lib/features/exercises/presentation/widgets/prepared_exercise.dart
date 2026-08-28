import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/attention_shape.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class PreparedExercise extends StatefulWidget {
  const PreparedExercise({
    super.key,
    required this.type,
    required this.builder,
    this.chooseDuration = true,
    this.defaultSeconds = 60,
    this.target,
    this.variant,
    this.briefingBody,
    this.briefingExtra,
  });

  final String type;
  final bool chooseDuration;
  final int defaultSeconds;
  final AttentionSymbol? target;
  final String? variant;
  final Widget Function(int durationSeconds) builder;
  final String? briefingBody;
  final Widget? briefingExtra;

  @override
  State<PreparedExercise> createState() => _PreparedExerciseState();
}

class _PreparedExerciseState extends State<PreparedExercise> {
  static const _durations = [60, 120, 180, 300];

  late int _seconds = _nearest(widget.defaultSeconds);
  bool _started = false;

  int _nearest(int seconds) {
    return _durations.reduce(
      (a, b) => (a - seconds).abs() <= (b - seconds).abs() ? a : b,
    );
  }

  @override
  void didUpdateWidget(covariant PreparedExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type ||
        oldWidget.target != widget.target ||
        oldWidget.variant != widget.variant) {
      _started = false;
      _seconds = _nearest(widget.defaultSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      child: _started
          ? KeyedSubtree(
              key: const ValueKey('running'),
              child: widget.builder(_seconds),
            )
          : KeyedSubtree(
              key: const ValueKey('briefing'),
              child: FadeSlideIn(child: _briefing(l10n)),
            ),
    );
  }

  Widget _briefing(AppLocalizations l10n) {
    final variant = widget.variant ?? '';
    final (title, fallbackBody) = switch ((widget.type, variant)) {
      ('attention', 'nogo') => (
        l10n.attentionBriefingNogoTitle,
        l10n.attentionBriefingNogoBody,
      ),
      ('attention', 'change') => (
        l10n.attentionBriefingChangeTitle,
        l10n.attentionBriefingChangeBody,
      ),
      ('attention', 'grid') => (
        l10n.attentionBriefingGridTitle,
        l10n.attentionBriefingGridBody,
      ),
      ('attention', _) => (
        l10n.attentionBriefingTitle,
        l10n.attentionBriefingBody,
      ),
      ('memory', 'icons') => (
        l10n.memoryBriefingIconsTitle,
        l10n.memoryBriefingIconsBody,
      ),
      ('memory', 'order') => (
        l10n.memoryBriefingOrderTitle,
        l10n.memoryBriefingOrderBody,
      ),
      ('memory', 'delayed') => (
        l10n.memoryBriefingDelayedTitle,
        l10n.memoryBriefingDelayedBody,
      ),
      ('memory', _) => (l10n.memoryBriefingTitle, l10n.memoryBriefingBody),
      ('breathing', 'box') => (
        l10n.breathingBriefingBoxTitle,
        l10n.breathingBriefingBoxBody,
      ),
      ('breathing', 'ladder') => (
        l10n.breathingBriefingLadderTitle,
        l10n.breathingBriefingLadderBody,
      ),
      ('breathing', 'tide') => (
        l10n.breathingBriefingTideTitle,
        l10n.breathingBriefingTideBody,
      ),
      ('breathing', _) => (
        l10n.breathingBriefingTitle,
        l10n.breathingBriefingBody,
      ),
      _ => (l10n.homeExercisesTitle, l10n.homeExercisesBody),
    };
    final body = widget.briefingBody?.trim().isNotEmpty == true
        ? widget.briefingBody!
        : fallbackBody;
    final showTarget =
        widget.type == 'attention' &&
        (variant.isEmpty || variant == 'target' || variant == 'nogo');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        AppText.title(title, align: TextAlign.center),
        const SizedBox(height: 16),
        AppText.subtitle(body, align: TextAlign.center),
        if (widget.briefingExtra != null) ...[
          const SizedBox(height: 16),
          widget.briefingExtra!,
        ],
        if (showTarget) ...[
          const SizedBox(height: 28),
          Text(
            variant == 'nogo'
                ? l10n.attentionNogoLabel
                : l10n.attentionTargetLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: AttentionShape(
              symbol: widget.target ?? AttentionSymbol.triangle,
              size: 120,
            ),
          ),
        ],
        if (widget.chooseDuration) ...[
          const SizedBox(height: 32),
          Text(
            l10n.exerciseDurationLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              for (final minutes in const [1, 2, 3, 5])
                ChoiceChip(
                  label: Text(l10n.exerciseDurationMinutes(minutes)),
                  selected: _seconds == minutes * 60,
                  onSelected: (_) => setState(() => _seconds = minutes * 60),
                ),
            ],
          ),
        ],
        const Spacer(),
        AppButton(
          label: l10n.exerciseBriefingStart,
          onPressed: () => setState(() => _started = true),
        ),
      ],
    );
  }
}
