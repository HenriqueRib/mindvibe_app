import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/progress/presentation/widgets/checkin_week_strip.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class CheckinMoodEnergy extends StatelessWidget {
  const CheckinMoodEnergy({
    super.key,
    required this.l10n,
    required this.mood,
    required this.energy,
    required this.onMood,
    required this.onEnergy,
  });

  final AppLocalizations l10n;
  final int? mood;
  final int? energy;
  final ValueChanged<int> onMood;
  final ValueChanged<int> onEnergy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckinAxis(
          title: l10n.checkinMoodTitle,
          selected: mood,
          labels: [
            for (var level = 1; level <= 5; level++) l10n.checkinMood('$level'),
          ],
          icons: const [
            Icons.sentiment_very_dissatisfied_outlined,
            Icons.sentiment_dissatisfied_outlined,
            Icons.sentiment_neutral_outlined,
            Icons.sentiment_satisfied_outlined,
            Icons.sentiment_very_satisfied_outlined,
          ],
          onSelect: (level) {
            HapticFeedback.selectionClick();
            onMood(level);
          },
        ),
        const SizedBox(height: 28),
        CheckinAxis(
          title: l10n.checkinEnergyTitle,
          selected: energy,
          labels: [
            for (var level = 1; level <= 5; level++) l10n.checkinEnergy('$level'),
          ],
          icons: const [
            Icons.battery_0_bar_outlined,
            Icons.battery_2_bar_outlined,
            Icons.battery_4_bar_outlined,
            Icons.battery_5_bar_outlined,
            Icons.battery_full_outlined,
          ],
          onSelect: (level) {
            HapticFeedback.selectionClick();
            onEnergy(level);
          },
        ),
      ],
    );
  }
}

class CheckinAxis extends StatelessWidget {
  const CheckinAxis({
    super.key,
    required this.title,
    required this.selected,
    required this.labels,
    required this.icons,
    required this.onSelect,
  });

  final String title;
  final int? selected;
  final List<String> labels;
  final List<IconData> icons;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final label = selected == null ? title : labels[selected! - 1];
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var level = 1; level <= 5; level++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: level == 5 ? 0 : 8),
                  child: _Dot(
                    selected: selected == level,
                    icon: icons[level - 1],
                    color: checkinTone(level),
                    onTap: () => onSelect(level),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.selected,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? color : color.withValues(alpha: 0.12),
            border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.28),
              width: selected ? 2 : 1,
            ),
          ),
          child: Icon(icon, color: selected ? Colors.white : color, size: 26),
        ),
      ),
    );
  }
}
