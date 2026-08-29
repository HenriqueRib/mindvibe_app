import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class RatingExerciseView extends StatefulWidget {
  const RatingExerciseView({
    super.key,
    required this.config,
    required this.onSubmit,
    this.title,
    this.body,
  });

  final RatingConfig config;
  final String? title;
  final String? body;
  final ValueChanged<int> onSubmit;

  @override
  State<RatingExerciseView> createState() => _RatingExerciseViewState();
}

class _RatingExerciseViewState extends State<RatingExerciseView> {
  int? _value;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prompt = widget.config.prompt ?? widget.title ?? l10n.ratingSelect;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.title(prompt),
        if (widget.body != null && widget.body!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          AppText.subtitle(widget.body!),
        ],
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (
              var value = widget.config.min;
              value <= widget.config.max;
              value++
            )
              ChoiceChip(
                label: Text(widget.config.labels[value] ?? '$value'),
                selected: _value == value,
                onSelected: (_) => setState(() => _value = value),
              ),
          ],
        ),
        const Spacer(),
        AppButton(
          label: l10n.actionContinue,
          onPressed: _value == null ? null : () => widget.onSubmit(_value!),
        ),
      ],
    );
  }
}
