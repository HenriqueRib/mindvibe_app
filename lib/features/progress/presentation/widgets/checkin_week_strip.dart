import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

Color checkinTone(int level) {
  return switch (level.clamp(1, 5)) {
    1 => const Color(0xFF8B5A52),
    2 => AppColors.accent,
    3 => AppColors.muted,
    4 => AppColors.primarySoft,
    _ => AppColors.primary,
  };
}

String checkinMoodLabel(AppLocalizations l10n, int level) {
  return l10n.checkinMood('$level');
}

String checkinEnergyLabel(AppLocalizations l10n, int level) {
  return l10n.checkinEnergy('$level');
}

String checkinPairLabel(AppLocalizations l10n, DayCheckin day) {
  if (!day.recorded) {
    return l10n.progressCheckinEmpty;
  }
  return l10n.progressCheckinBody(
    checkinMoodLabel(l10n, day.mood!),
    checkinEnergyLabel(l10n, day.energy!),
  );
}

class CheckinClimateRow extends StatelessWidget {
  const CheckinClimateRow({
    super.key,
    required this.l10n,
    required this.checkin,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final CheckinSnapshot checkin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final today = checkin.today;
    final weight = today?.weightLevel;
    final filled = today != null;
    final color = filled ? checkinTone(weight ?? 3) : AppColors.accent;
    final title = filled
        ? l10n.checkinWeight('$weight')
        : l10n.progressCheckinTitle;
    final hint = filled
        ? checkinPairLabel(l10n, today)
        : l10n.progressCheckinCta;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: filled ? AppColors.muted : AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckinClimateCard extends StatelessWidget {
  const CheckinClimateCard({
    super.key,
    required this.l10n,
    required this.checkin,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final CheckinSnapshot checkin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final today = checkin.today;
    final weight = today?.weightLevel;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressCheckinTitle,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          if (today == null) ...[
            Text(
              l10n.progressCheckinEmpty,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.progressCheckinCta,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Text(
              l10n.checkinWeight('$weight'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              checkinPairLabel(l10n, today),
              style: const TextStyle(color: AppColors.muted, height: 1.35),
            ),
          ],
          if (checkin.days.isNotEmpty) ...[
            const SizedBox(height: 16),
            CheckinWeekStrip(days: checkin.days, l10n: l10n),
          ],
          const SizedBox(height: 14),
          Text(
            l10n.progressStreakCheckinHint,
            style: const TextStyle(
              color: AppColors.muted,
              height: 1.4,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class CheckinWeekStrip extends StatelessWidget {
  const CheckinWeekStrip({super.key, required this.days, required this.l10n});

  final List<DayCheckin> days;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final points = days.length == 7 ? days : const <DayCheckin>[];
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (final day in points)
          Expanded(
            child: _DayDot(day: day, locale: l10n.localeName),
          ),
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.day, required this.locale});

  final DayCheckin day;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday =
        day.date.year == today.year &&
        day.date.month == today.month &&
        day.date.day == today.day;
    final recorded = day.recorded;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final tone = recorded
        ? checkinTone(day.weightLevel ?? 3)
        : AppColors.border;
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
          width: recorded ? 16 : 10,
          height: recorded ? 16 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: recorded ? tone : Colors.transparent,
            border: Border.all(color: tone, width: isToday ? 2 : 1.4),
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
