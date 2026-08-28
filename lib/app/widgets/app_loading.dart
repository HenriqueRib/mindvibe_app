import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_brand_mark.dart';
import 'package:mindvibe_app/app/widgets/app_motion.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.label,
    this.title,
    this.body,
    this.markSize = 80,
    this.color,
  }) : compact = false,
       compactSize = 22;

  const AppLoading.compact({super.key, this.color, this.compactSize = 22})
    : label = null,
      title = null,
      body = null,
      markSize = 80,
      compact = true;

  final String? label;
  final String? title;
  final String? body;
  final double markSize;
  final bool compact;
  final double compactSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _ArcSpinner(size: compactSize, color: color, stroke: 2.2);
    }

    final scheme = Theme.of(context).colorScheme;
    final glow = markSize * 2.35;
    final ring = markSize + 28;
    return Center(
      child: FadeSlideIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: glow,
                height: glow,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: glow,
                      height: glow,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (color ?? scheme.primary).withValues(alpha: 0.28),
                            (color ?? scheme.primary).withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                          stops: const [0.18, 0.52, 1],
                        ),
                      ),
                    ),
                    _ArcSpinner(
                      size: ring,
                      color: (color ?? scheme.primary).withValues(alpha: 0.45),
                      stroke: 2.4,
                    ),
                    AppBrandMark(size: markSize, pulse: true),
                  ],
                ),
              ),
              if (title != null) ...[
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: markSize >= 100 ? 32 : 24,
                    fontWeight: FontWeight.w700,
                    color: color ?? scheme.primary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (label != null) ...[
                Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: title == null ? 15 : 18,
                    fontWeight: title == null
                        ? FontWeight.w500
                        : FontWeight.w600,
                    color: title == null ? AppColors.muted : scheme.onSurface,
                  ),
                ),
              ],
              if (body != null) ...[
                const SizedBox(height: 10),
                Text(
                  body!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    color: scheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ArcSpinner extends StatelessWidget {
  const _ArcSpinner({required this.size, required this.stroke, this.color});

  final double size;
  final double stroke;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: stroke,
        color: color ?? Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
