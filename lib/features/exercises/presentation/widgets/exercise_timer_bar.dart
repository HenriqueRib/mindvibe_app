import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';

class ExerciseTimerBar extends StatelessWidget {
  const ExerciseTimerBar({
    super.key,
    required this.remaining,
    required this.total,
  });

  final Duration remaining;
  final Duration total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final totalMs = total.inMilliseconds <= 0 ? 1 : total.inMilliseconds;
    final left = remaining.isNegative ? Duration.zero : remaining;
    final progress = (left.inMilliseconds / totalMs).clamp(0.0, 1.0);
    final ending = left.inSeconds <= 10;
    final color = ending ? AppColors.accent : scheme.primary;
    final minutes = left.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = left.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: progress, end: progress),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: scheme.surfaceContainerHighest,
                color: color,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 280),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: ending ? AppColors.accent : scheme.onSurfaceVariant,
          ),
          child: Text('$minutes:$seconds'),
        ),
      ],
    );
  }
}
