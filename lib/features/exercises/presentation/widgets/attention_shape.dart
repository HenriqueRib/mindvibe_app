import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';

Color attentionSymbolColor(AttentionSymbol symbol) {
  return switch (symbol) {
    AttentionSymbol.circle => const Color(0xFF5B8DEF),
    AttentionSymbol.square => const Color(0xFF3D9A6A),
    AttentionSymbol.triangle => const Color(0xFFE07A3D),
  };
}

class AttentionShape extends StatelessWidget {
  const AttentionShape({
    super.key,
    required this.symbol,
    this.size = 96,
    this.color,
    this.onTap,
  });

  final AttentionSymbol symbol;
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? attentionSymbolColor(symbol);
    final painter = _AttentionShapePainter(
      symbol: symbol,
      color: resolved,
      extent: size,
    );
    final shape = CustomPaint(size: Size.square(size), painter: painter);
    if (onTap == null) {
      return shape;
    }
    return ScaleOnTap(
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: onTap,
        child: shape,
      ),
    );
  }
}

class _AttentionShapePainter extends CustomPainter {
  _AttentionShapePainter({
    required this.symbol,
    required this.color,
    required this.extent,
  });

  final AttentionSymbol symbol;
  final Color color;
  final double extent;

  Path _path(Size size) {
    final stroke = (size.shortestSide * 0.08).clamp(4, 10).toDouble();
    final inset = stroke;
    final rect =
        Offset(inset, inset) &
        Size(size.width - inset * 2, size.height - inset * 2);
    return switch (symbol) {
      AttentionSymbol.circle => Path()..addOval(rect),
      AttentionSymbol.square =>
        Path()..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.12)),
        ),
      AttentionSymbol.triangle =>
        Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close(),
    };
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _path(size);
    final strokeWidth = (size.shortestSide * 0.08).clamp(4, 10).toDouble();
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.16)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool? hitTest(Offset position) {
    return _path(Size.square(extent)).contains(position);
  }

  @override
  bool shouldRepaint(covariant _AttentionShapePainter oldDelegate) {
    return oldDelegate.symbol != symbol ||
        oldDelegate.color != color ||
        oldDelegate.extent != extent;
  }
}
