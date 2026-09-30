import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/exercises/domain/blink_cycle.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/exercise_timer_bar.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class BlinkExerciseView extends StatefulWidget {
  const BlinkExerciseView({
    super.key,
    required this.config,
    required this.onCompleted,
    this.setIndex,
    this.setsPerDay,
  });

  final BlinkCycleConfig config;
  final ValueChanged<int> onCompleted;
  final int? setIndex;
  final int? setsPerDay;

  @override
  State<BlinkExerciseView> createState() => _BlinkExerciseViewState();
}

class _BlinkExerciseViewState extends State<BlinkExerciseView>
    with TickerProviderStateMixin {
  late final BlinkCycleEngine _engine;
  late final AnimationController _lid;
  late final AnimationController _phaseClock;
  late final AnimationController _glow;
  Timer? _timer;
  final _startedAt = DateTime.now();
  bool _finished = false;
  BlinkPhase? _phase;

  @override
  void initState() {
    super.initState();
    _engine = BlinkCycleEngine(widget.config);
    _lid = AnimationController(vsync: this, duration: Duration.zero);
    _phaseClock = AnimationController(vsync: this, duration: Duration.zero);
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    if (state.completed) {
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

  void _startPhase(BlinkCycleState state) {
    _phase = state.phase;
    final seconds = math.max(1, widget.config.durationOf(state.phase));
    final duration = Duration(seconds: seconds);
    _phaseClock.duration = duration;
    _phaseClock.forward(from: 0);

    switch (state.phase) {
      case BlinkPhase.lookAway:
        _lid.duration = const Duration(milliseconds: 400);
        _lid.animateTo(0.15, curve: Curves.easeOut);
      case BlinkPhase.close:
        _lid.duration = duration;
        _lid.animateTo(1, curve: Curves.easeInOutCubic);
      case BlinkPhase.squeeze:
        _lid.duration = const Duration(milliseconds: 280);
        _lid.animateTo(1, curve: Curves.easeOut);
      case BlinkPhase.open:
        _lid.duration = duration;
        _lid.animateTo(0, curve: Curves.easeInOutCubic);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _lid.dispose();
    _phaseClock.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = _engine.state;
    final label = switch (state.phase) {
      BlinkPhase.lookAway => l10n.blinkLookAway,
      BlinkPhase.close => l10n.blinkClose,
      BlinkPhase.squeeze => l10n.blinkSqueeze,
      BlinkPhase.open => l10n.blinkOpen,
    };
    final night = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final total = Duration(seconds: widget.config.totalSeconds);
    var remaining = total - DateTime.now().difference(_startedAt);
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
              animation: Listenable.merge([_lid, _phaseClock, _glow]),
              builder: (context, child) {
                return CustomPaint(
                  painter: _BlinkPainter(
                    lid: _lid.value,
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
          state.inLookAway
              ? l10n.blinkLookAwayHint
              : l10n.blinkCycle(state.cycleIndex, widget.config.reps),
          textAlign: TextAlign.center,
          style: TextStyle(color: muted),
        ),
        if (widget.setIndex != null && widget.setsPerDay != null) ...[
          const SizedBox(height: 6),
          Text(
            l10n.blinkSetProgress(widget.setIndex!, widget.setsPerDay!),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
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

class _BlinkPainter extends CustomPainter {
  _BlinkPainter({
    required this.lid,
    required this.phaseProgress,
    required this.glow,
    required this.phase,
    required this.night,
    required this.variant,
  });

  final double lid;
  final double phaseProgress;
  final double glow;
  final BlinkPhase phase;
  final bool night;
  final BlinkVariant variant;

  Color get _color => switch (variant) {
    BlinkVariant.closeSqueezeOpen => const Color(0xFF4A7C9B),
    BlinkVariant.completeBlinks => const Color(0xFF5B8FA8),
    BlinkVariant.screenBreak20 => const Color(0xFF6A9B7A),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide / 2;
    final color = _color;
    final eyeWidth = maxRadius * 1.35;
    final eyeHeight = maxRadius * (0.55 - lid * 0.48);
    final eyeRect = Rect.fromCenter(
      center: center,
      width: eyeWidth,
      height: math.max(6, eyeHeight * 2),
    );

    canvas.drawCircle(
      center,
      maxRadius * (0.92 + glow * 0.04),
      Paint()
        ..color = color.withValues(alpha: (0.12 + (1 - lid) * 0.18) * (night ? 0.9 : 0.7))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24),
    );

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..color = color.withValues(alpha: 0.85);
    canvas.drawOval(eyeRect, outline);

    if (lid < 0.92) {
      final pupilRadius = maxRadius * 0.18 * (1 - lid * 0.35);
      canvas.drawCircle(
        center,
        pupilRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Color.lerp(color, Colors.white, night ? 0.2 : 0.35)!,
              color,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: pupilRadius)),
      );
    }

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

    if (phase == BlinkPhase.lookAway) {
      final tip = Offset(center.dx, center.dy - maxRadius * 0.72);
      canvas.drawCircle(
        tip,
        5 + glow * 2,
        Paint()..color = AppColors.primarySoft.withValues(alpha: 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BlinkPainter oldDelegate) {
    return oldDelegate.lid != lid ||
        oldDelegate.phaseProgress != phaseProgress ||
        oldDelegate.glow != glow ||
        oldDelegate.phase != phase ||
        oldDelegate.night != night ||
        oldDelegate.variant != variant;
  }
}
