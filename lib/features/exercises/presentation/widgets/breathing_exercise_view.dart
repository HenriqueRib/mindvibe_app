import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/breathing_cycle.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/exercise_timer_bar.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class BreathingExerciseView extends StatefulWidget {
  const BreathingExerciseView({
    super.key,
    required this.config,
    required this.onCompleted,
    this.sessionSeconds,
  });

  final BreathingCycleConfig config;
  final ValueChanged<int> onCompleted;
  final int? sessionSeconds;

  @override
  State<BreathingExerciseView> createState() => _BreathingExerciseViewState();
}

class _BreathingExerciseViewState extends State<BreathingExerciseView>
    with TickerProviderStateMixin {
  late final BreathingCycleEngine _engine;
  late final AnimationController _breath;
  late final AnimationController _phaseClock;
  late final AnimationController _glow;
  Timer? _timer;
  final _startedAt = DateTime.now();
  bool _finished = false;
  BreathingPhase? _phase;

  @override
  void initState() {
    super.initState();
    _engine = BreathingCycleEngine(widget.config);
    _breath = AnimationController(vsync: this, duration: Duration.zero);
    _phaseClock = AnimationController(vsync: this, duration: Duration.zero);
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _startPhase(_engine.state);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final previous = _engine.state.phase;
    final state = _engine.tick();
    if (!mounted) {
      return;
    }
    setState(() {});
    final session = widget.sessionSeconds;
    final timeUp =
        session != null &&
        DateTime.now().difference(_startedAt).inSeconds >= session;
    if (state.completed || timeUp) {
      _timer?.cancel();
      _glow.stop();
      if (!_finished) {
        _finished = true;
        widget.onCompleted(
          DateTime.now().difference(_startedAt).inMilliseconds,
        );
      }
      return;
    }
    if (state.phase != previous) {
      _startPhase(state);
    }
  }

  void _startPhase(BreathingCycleState state) {
    _phase = state.phase;
    final seconds = math.max(1, widget.config.durationOf(state.phase));
    final duration = Duration(seconds: seconds);
    _phaseClock.duration = duration;
    _phaseClock.forward(from: 0);

    switch (state.phase) {
      case BreathingPhase.inspiration:
        _breath.duration = duration;
        _breath.animateTo(1, curve: Curves.easeInOutCubic);
      case BreathingPhase.hold:
        _breath.duration = const Duration(milliseconds: 280);
        _breath.animateTo(1, curve: Curves.easeOut);
      case BreathingPhase.expiration:
        _breath.duration = duration;
        _breath.animateTo(0, curve: Curves.easeInOutCubic);
      case BreathingPhase.rest:
        _breath.duration = duration;
        _breath.animateTo(0.12, curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breath.dispose();
    _phaseClock.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = _engine.state;
    final label = switch (state.phase) {
      BreathingPhase.inspiration => l10n.breathingInhale,
      BreathingPhase.hold => l10n.breathingHold,
      BreathingPhase.expiration => l10n.breathingExhale,
      BreathingPhase.rest => l10n.breathingRest,
    };
    final night = Theme.of(context).brightness == Brightness.dark;

    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final session = widget.sessionSeconds;
    final elapsed = DateTime.now().difference(_startedAt);
    final total = session == null
        ? Duration(seconds: widget.config.cycles * widget.config.cycleSeconds)
        : Duration(seconds: session);
    var remaining = total - elapsed;
    if (remaining.isNegative) {
      remaining = Duration.zero;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExerciseTimerBar(remaining: remaining, total: total),
        const Spacer(),
        Center(
          child: SizedBox(
            width: 280,
            height: 280,
            child: AnimatedBuilder(
              animation: Listenable.merge([_breath, _phaseClock, _glow]),
              builder: (context, child) {
                return CustomPaint(
                  painter: _BreathPainter(
                    fill: _breath.value,
                    phaseProgress: _phaseClock.value,
                    glow: _glow.value,
                    phase: _phase ?? state.phase,
                    night: night,
                    variant: widget.config.variant,
                  ),
                  child: child,
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        transitionBuilder: fadeScaleSwitcher,
                        child: Text(
                          label,
                          key: ValueKey(label),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${state.secondsLeft}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.breathingCycle(state.cycleIndex, widget.config.cycles),
          textAlign: TextAlign.center,
          style: TextStyle(color: muted),
        ),
        const Spacer(),
        if (state.completed)
          AppButton(
            label: l10n.actionContinue,
            onPressed: () {
              if (_finished) {
                return;
              }
              _finished = true;
              widget.onCompleted(
                DateTime.now().difference(_startedAt).inMilliseconds,
              );
            },
          ),
      ],
    );
  }
}

class _BreathPainter extends CustomPainter {
  _BreathPainter({
    required this.fill,
    required this.phaseProgress,
    required this.glow,
    required this.phase,
    required this.night,
    required this.variant,
  });

  final double fill;
  final double phaseProgress;
  final double glow;
  final BreathingPhase phase;
  final bool night;
  final BreathingVariant variant;

  Color get _color => switch (variant) {
    BreathingVariant.wave => switch (phase) {
      BreathingPhase.inspiration => AppColors.primarySoft,
      BreathingPhase.hold => AppColors.primary,
      BreathingPhase.expiration => const Color(0xFF6A8B84),
      BreathingPhase.rest => AppColors.muted,
    },
    BreathingVariant.box => const Color(0xFF2F7A8A),
    BreathingVariant.ladder => const Color(0xFF8B6BB5),
    BreathingVariant.tide => const Color(0xFF3D7A9A),
  };

  @override
  void paint(Canvas canvas, Size size) {
    switch (variant) {
      case BreathingVariant.box:
        _paintBox(canvas, size);
      case BreathingVariant.ladder:
        _paintLadder(canvas, size);
      case BreathingVariant.tide:
        _paintTide(canvas, size);
      case BreathingVariant.wave:
        _paintWave(canvas, size);
    }
  }

  void _paintWave(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide / 2;
    final coreRadius = maxRadius * (0.34 + fill * 0.28);
    final inhaling = phase == BreathingPhase.inspiration;
    final exhaling = phase == BreathingPhase.expiration;
    final holding = phase == BreathingPhase.hold;
    final color = _color;

    final glowStrength = 0.18 + fill * 0.38 + (holding ? glow * 0.12 : 0);
    canvas.drawCircle(
      center,
      coreRadius * (1.55 + fill * 0.35),
      Paint()
        ..color = color.withValues(alpha: glowStrength * (night ? 0.55 : 0.42))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
    );

    const ringCount = 4;
    for (var i = 0; i < ringCount; i++) {
      final wave = inhaling
          ? fill
          : exhaling
          ? 1 - fill
          : holding
          ? 0.85 + glow * 0.08
          : 0.2;
      final spread = (i + 1) / ringCount;
      final radius = coreRadius * (1.08 + spread * 0.62 * wave);
      final fade = (1 - spread) * (0.18 + fill * 0.35);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = inhaling
              ? 2.4
              : exhaling
              ? 1.6
              : 1.8
          ..color = color.withValues(alpha: fade.clamp(0.05, 0.45)),
      );
    }

    if (inhaling || exhaling) {
      const dots = 10;
      final drift = inhaling ? fill : 1 - fill;
      for (var i = 0; i < dots; i++) {
        final angle =
            (i / dots) * math.pi * 2 +
            phaseProgress * (inhaling ? 0.35 : -0.35);
        final distance = coreRadius * (1.15 + drift * 0.55);
        final dot = Offset(
          center.dx + math.cos(angle) * distance,
          center.dy + math.sin(angle) * distance,
        );
        canvas.drawCircle(
          dot,
          inhaling ? 2.6 : 2.0,
          Paint()
            ..color = color.withValues(
              alpha: (0.18 + fill * 0.35).clamp(0.08, 0.5),
            ),
        );
      }
    }

    canvas.drawCircle(
      center,
      coreRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Color.lerp(color, Colors.white, night ? 0.18 : 0.28)!,
            color,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: coreRadius)),
    );

    final arcRect = Rect.fromCircle(center: center, radius: maxRadius * 0.92);
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = color.withValues(alpha: 0.18),
    );
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 2 * (1 - phaseProgress.clamp(0.0, 1.0)),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.5
        ..color = color.withValues(alpha: 0.85),
    );
  }

  void _paintBox(Canvas canvas, Size size) {
    final color = _color;
    final inset = size.shortestSide * 0.12;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(22));
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = color.withValues(alpha: 0.22),
    );

    final t = phaseProgress.clamp(0.0, 1.0);
    final side = switch (phase) {
      BreathingPhase.inspiration => (rect.bottomLeft, rect.topLeft),
      BreathingPhase.hold => (rect.topLeft, rect.topRight),
      BreathingPhase.expiration => (rect.topRight, rect.bottomRight),
      BreathingPhase.rest => (rect.bottomRight, rect.bottomLeft),
    };
    final from = side.$1;
    final to = side.$2;
    canvas.drawLine(
      from,
      Offset.lerp(from, to, t)!,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5
        ..color = color,
    );

    final orb = Offset.lerp(from, to, t)!;
    final orbRadius = 9.0 + (phase == BreathingPhase.hold ? glow * 3 : 0);
    canvas.drawCircle(
      orb,
      orbRadius * 2.2,
      Paint()
        ..color = color.withValues(alpha: night ? 0.28 : 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
    canvas.drawCircle(orb, orbRadius, Paint()..color = color);
  }

  void _paintLadder(Canvas canvas, Size size) {
    final color = _color;
    final width = size.width * 0.28;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: width,
      height: size.height * 0.86,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(28));
    canvas.drawRRect(
      rrect,
      Paint()..color = color.withValues(alpha: night ? 0.12 : 0.08),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color.withValues(alpha: 0.28),
    );

    final amount = switch (phase) {
      BreathingPhase.inspiration => phaseProgress,
      BreathingPhase.hold => 1.0,
      BreathingPhase.expiration => 1 - phaseProgress,
      BreathingPhase.rest => 0.08,
    }.clamp(0.0, 1.0);
    final fillHeight = rect.height * amount;
    if (fillHeight > 2) {
      final fillRect = Rect.fromLTWH(
        rect.left,
        rect.bottom - fillHeight,
        rect.width,
        fillHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(fillRect, const Radius.circular(28)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              color,
              Color.lerp(color, Colors.white, night ? 0.18 : 0.28)!,
            ],
          ).createShader(fillRect),
      );
    }

    for (final fraction in const [4 / 19, 11 / 19, 1.0]) {
      final y = rect.bottom - rect.height * fraction;
      canvas.drawLine(
        Offset(rect.left - 10, y),
        Offset(rect.right + 10, y),
        Paint()
          ..strokeWidth = 1.4
          ..color = color.withValues(alpha: 0.35),
      );
    }
  }

  void _paintTide(Canvas canvas, Size size) {
    final color = _color;
    final amount = switch (phase) {
      BreathingPhase.inspiration => phaseProgress,
      BreathingPhase.hold => 1.0,
      BreathingPhase.expiration => 1 - phaseProgress,
      BreathingPhase.rest => 0.12,
    }.clamp(0.0, 1.0);
    final waterTop = size.height * (0.72 - amount * 0.46);
    final path = Path()..moveTo(0, size.height);
    const steps = 28;
    for (var i = 0; i <= steps; i++) {
      final x = size.width * (i / steps);
      final wave =
          math.sin((i / steps) * math.pi * 2 + phaseProgress * math.pi * 2) * 7;
      path.lineTo(x, waterTop + wave);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            color.withValues(alpha: night ? 0.55 : 0.42),
            color.withValues(alpha: 0.85),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(28)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color.withValues(alpha: 0.22),
    );
  }

  @override
  bool shouldRepaint(covariant _BreathPainter oldDelegate) {
    return oldDelegate.fill != fill ||
        oldDelegate.phaseProgress != phaseProgress ||
        oldDelegate.glow != glow ||
        oldDelegate.phase != phase ||
        oldDelegate.night != night ||
        oldDelegate.variant != variant;
  }
}
