import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class WeekTimeChart extends StatelessWidget {
  const WeekTimeChart({
    super.key,
    required this.days,
    this.title,
    this.insight,
    this.compact = false,
  });

  final List<WeekDayTime> days;
  final String? title;
  final String? insight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final points = days.length == 7 ? days : weekDaysFromHistory(const []);
    final total = points.fold<int>(0, (sum, day) => sum + day.seconds);
    final night = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? l10n.progressWeekChartTitle,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 4),
          if (total == 0)
            Text(
              l10n.progressWeekChartEmpty,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            )
          else ...[
            Text(
              l10n.progressWeekChartTotal(_formatMinutes(l10n, total)),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            if (insight != null) ...[
              const SizedBox(height: 6),
              Text(
                insight!,
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
            ],
          ],
          const SizedBox(height: 16),
          SizedBox(
            height: compact ? 132 : 176,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 720),
              curve: Curves.easeOutCubic,
              builder: (context, t, _) {
                return CustomPaint(
                  painter: _WeekTimePainter(
                    days: points,
                    progress: t,
                    locale: l10n.localeName,
                    night: night,
                    formatMinutes: (seconds) => _compactMinutes(seconds),
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatMinutes(AppLocalizations l10n, int seconds) {
    if (seconds < 60) {
      return l10n.progressTimeUnderMinute;
    }
    return l10n.progressTimeOnlyMinutes((seconds / 60).round());
  }

  String _compactMinutes(int seconds) {
    if (seconds < 60) {
      return '<1';
    }
    return '${(seconds / 60).round()}';
  }
}

List<WeekDayTime> weekDaysFromHistory(
  List<ActivityItem> items, {
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  return [
    for (var offset = 6; offset >= 0; offset--)
      _bucketFor(today.subtract(Duration(days: offset)), items),
  ];
}

WeekDayTime _bucketFor(DateTime date, List<ActivityItem> items) {
  var seconds = 0;
  for (final item in items) {
    final local = item.occurredAt.toLocal();
    if (local.year == date.year &&
        local.month == date.month &&
        local.day == date.day) {
      seconds += item.seconds;
    }
  }
  return WeekDayTime(date: date, seconds: seconds);
}

class _WeekTimePainter extends CustomPainter {
  _WeekTimePainter({
    required this.days,
    required this.progress,
    required this.locale,
    required this.night,
    required this.formatMinutes,
  });

  final List<WeekDayTime> days;
  final double progress;
  final String locale;
  final bool night;
  final String Function(int seconds) formatMinutes;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 36.0;
    const bottom = 28.0;
    const top = 18.0;
    final chart = Rect.fromLTRB(left, top, size.width, size.height - bottom);
    if (chart.width <= 0 || chart.height <= 0 || days.isEmpty) {
      return;
    }

    final maxSeconds = days.fold<int>(
      0,
      (sum, day) => math.max(sum, day.seconds),
    );
    final axisMax = _niceMax(maxSeconds);
    final gridPaint = Paint()
      ..color = (night ? Colors.white : AppColors.text).withValues(alpha: 0.08)
      ..strokeWidth = 1;
    const labelStyle = TextStyle(
      color: AppColors.muted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    for (final fraction in [0.0, 0.5, 1.0]) {
      final y = chart.bottom - chart.height * fraction;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final seconds = (axisMax * fraction).round();
      _paintText(
        canvas,
        _axisLabel(seconds),
        Offset(0, y - 7),
        labelStyle,
        width: left - 6,
        align: TextAlign.right,
      );
    }

    final slot = chart.width / days.length;
    final barWidth = math.min(28.0, slot * 0.52);
    final today = DateTime.now();

    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final isToday =
          day.date.year == today.year &&
          day.date.month == today.month &&
          day.date.day == today.day;
      final ratio = axisMax == 0 ? 0.0 : day.seconds / axisMax;
      final barHeight = math.max<double>(
        day.seconds > 0 ? 8 : 5,
        chart.height * ratio * progress,
      );
      final centerX = chart.left + slot * i + slot / 2;
      final rect = RRect.fromRectAndCorners(
        Rect.fromCenter(
          center: Offset(centerX, chart.bottom - barHeight / 2),
          width: barWidth,
          height: barHeight,
        ),
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(10),
      );
      final color = day.seconds == 0
          ? (night ? const Color(0xFF2A302E) : AppColors.surfaceMuted)
          : isToday
          ? AppColors.primary
          : AppColors.primarySoft;
      canvas.drawRRect(rect, Paint()..color = color);

      if (day.seconds > 0 && progress > 0.85) {
        _paintText(
          canvas,
          formatMinutes(day.seconds),
          Offset(centerX - slot / 2, rect.top - 16),
          TextStyle(
            color: isToday ? AppColors.primary : AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          width: slot,
          align: TextAlign.center,
        );
      }

      _paintText(
        canvas,
        _weekday(day.date),
        Offset(centerX - slot / 2, chart.bottom + 8),
        TextStyle(
          color: isToday ? AppColors.text : AppColors.muted,
          fontSize: 12,
          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
        ),
        width: slot,
        align: TextAlign.center,
      );
    }
  }

  String _weekday(DateTime date) {
    final raw = DateFormat('E', locale).format(date).replaceAll('.', '');
    if (raw.isEmpty) {
      return '';
    }
    final short = raw.length <= 3 ? raw : raw.substring(0, 3);
    return '${short[0].toUpperCase()}${short.substring(1).toLowerCase()}';
  }

  String _axisLabel(int seconds) {
    if (seconds <= 0) {
      return '0';
    }
    if (seconds < 60) {
      return '${seconds}s';
    }
    return '${(seconds / 60).round()}';
  }

  int _niceMax(int seconds) {
    if (seconds <= 0) {
      return 30 * 60;
    }
    final minutes = (seconds / 60).ceil();
    const steps = [5, 10, 15, 20, 30, 45, 60, 90, 120, 180, 240];
    for (final step in steps) {
      if (minutes <= step) {
        return step * 60;
      }
    }
    return ((minutes / 60).ceil() * 60) * 60;
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style, {
    required double width,
    required TextAlign align,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
      textAlign: align,
      maxLines: 1,
    )..layout(maxWidth: width);
    final dx = align == TextAlign.right
        ? offset.dx + width - painter.width
        : align == TextAlign.center
        ? offset.dx + (width - painter.width) / 2
        : offset.dx;
    painter.paint(canvas, Offset(dx, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _WeekTimePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.night != night ||
        oldDelegate.days != days;
  }
}
