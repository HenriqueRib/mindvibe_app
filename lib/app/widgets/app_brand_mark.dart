import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_motion.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({super.key, this.size = 96, this.pulse = false});

  final double size;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    final mark = Image.asset(
      'assets/branding/APP_ICON_CERTO.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      fit: BoxFit.contain,
    );
    if (!pulse) {
      return mark;
    }
    return Pulse(minScale: 0.96, maxScale: 1.04, child: mark);
  }
}
