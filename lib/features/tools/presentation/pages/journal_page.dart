import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/tools/presentation/providers/journal_controller.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({super.key});

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  final _lines = List.generate(3, (_) => TextEditingController());
  var _filled = false;

  @override
  void dispose() {
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  void _fill(JournalEntry? today) {
    if (_filled) {
      return;
    }
    _filled = true;
    if (today == null) {
      return;
    }
    for (var index = 0; index < _lines.length; index++) {
      _lines[index].text = index < today.lines.length ? today.lines[index] : '';
    }
  }

  List<String> _currentLines() {
    return [for (final line in _lines) line.text.trim()];
  }

  bool get _hasContent => _currentLines().any((line) => line.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(journalControllerProvider);
    final runner = ref.read(journalControllerProvider.notifier);

    ref.listen(journalControllerProvider, (previous, next) {
      if (previous?.loading == true && !next.loading) {
        _fill(next.snapshot.today);
      }
    });

    return AppScaffold(
      showBack: true,
      title: l10n.journalTitle,
      body: state.loading
          ? AppLoading(label: l10n.loadingLabel)
          : ListView(
              children: [
                AppText.subtitle(l10n.journalHint, align: TextAlign.center),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final prompt in JournalPrompt.values)
                      _PromptChip(
                        label: l10n.journalPrompt(prompt.name),
                        selected: state.prompt == prompt,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          runner.setPrompt(prompt);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.journalPromptHint(state.prompt.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                for (var index = 0; index < 3; index++) ...[
                  if (index > 0) const SizedBox(height: 12),
                  TextField(
                    controller: _lines[index],
                    maxLength: 160,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: _placeholder(l10n, state.prompt, index),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (state.failure != null) ...[
                  AppInlineError(message: failureMessage(state.failure!, l10n)),
                  const SizedBox(height: 12),
                ],
                AppButton(
                  label: state.saved ? l10n.journalUpdate : l10n.journalSave,
                  loading: state.saving,
                  onPressed: !_hasContent || state.saving
                      ? null
                      : () => runner.save(_currentLines()),
                ),
                const SizedBox(height: 12),
                Text(
                  state.saved ? l10n.journalSaved : l10n.journalPrivate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                if (state.snapshot.days.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    l10n.journalWeek,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _WeekDots(days: state.snapshot.days, l10n: l10n),
                ],
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  String _placeholder(AppLocalizations l10n, JournalPrompt prompt, int index) {
    return switch ((prompt, index)) {
      (JournalPrompt.intention, 0) => l10n.journalIntention1,
      (JournalPrompt.intention, 1) => l10n.journalIntention2,
      (JournalPrompt.intention, 2) => l10n.journalIntention3,
      (JournalPrompt.unload, 0) => l10n.journalUnload1,
      (JournalPrompt.unload, 1) => l10n.journalUnload2,
      (JournalPrompt.unload, 2) => l10n.journalUnload3,
      (JournalPrompt.gratitude, 0) => l10n.journalGratitude1,
      (JournalPrompt.gratitude, 1) => l10n.journalGratitude2,
      _ => l10n.journalGratitude3,
    };
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: scheme.primary,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: selected ? scheme.primary : scheme.outline),
    );
  }
}

class _WeekDots extends StatelessWidget {
  const _WeekDots({required this.days, required this.l10n});

  final List<JournalDay> days;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final points = days.length == 7 ? days : const <JournalDay>[];
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        for (final day in points)
          Expanded(
            child: _Dot(
              day: day,
              locale: l10n.localeName,
              onSurface: onSurface,
              muted: muted,
            ),
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.day,
    required this.locale,
    required this.onSurface,
    required this.muted,
  });

  final JournalDay day;
  final String locale;
  final Color onSurface;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final scheme = Theme.of(context).colorScheme;
    final isToday =
        day.date.year == now.year &&
        day.date.month == now.month &&
        day.date.day == now.day;
    final raw = DateFormat('E', locale).format(day.date).replaceAll('.', '');
    final short = raw.isEmpty
        ? ''
        : (raw.length <= 3 ? raw : raw.substring(0, 3));
    final label = short.isEmpty
        ? ''
        : '${short[0].toUpperCase()}${short.substring(1).toLowerCase()}';

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: day.written ? 16 : 10,
          height: day.written ? 16 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: day.written ? scheme.primary : Colors.transparent,
            border: Border.all(
              color: day.written ? scheme.primary : scheme.outline,
              width: isToday ? 2 : 1.4,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? onSurface : muted,
          ),
        ),
      ],
    );
  }
}
