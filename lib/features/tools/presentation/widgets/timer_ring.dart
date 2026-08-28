import 'package:flutter/material.dart';

class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.progress,
    required this.color,
    required this.track,
    required this.child,
    this.size = 240,
  });

  final double progress;
  final Color color;
  final Color track;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress, color: color, track: track),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      0,
      6.283185307179586,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    if (progress <= 0) {
      return;
    }
    canvas.drawArc(
      rect,
      -1.5707963267948966,
      6.283185307179586 * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
