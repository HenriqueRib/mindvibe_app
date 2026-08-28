import 'package:flutter/material.dart';

class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 480),
    this.offset = 18,
  });

  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = curved;
    _slide = Tween(
      begin: Offset(0, widget.offset / 80),
      end: Offset.zero,
    ).animate(curved);
    final wait = widget.delay + Duration(milliseconds: 70 * widget.index);
    Future<void>.delayed(wait, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class Pulse extends StatefulWidget {
  const Pulse({
    super.key,
    required this.child,
    this.enabled = true,
    this.minScale = 0.97,
    this.maxScale = 1.03,
    this.duration = const Duration(milliseconds: 1600),
  });

  final Widget child;
  final bool enabled;
  final double minScale;
  final double maxScale;
  final Duration duration;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _sync();
  }

  @override
  void didUpdateWidget(covariant Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    _sync();
  }

  void _sync() {
    if (widget.enabled) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
      return;
    }
    _controller.stop();
    _controller.value = 0.5;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(
        begin: widget.minScale,
        end: widget.maxScale,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: widget.child,
    );
  }
}

class SoftPageTransitionsBuilder extends PageTransitionsBuilder {
  const SoftPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

Widget fadeScaleSwitcher(Widget child, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween(
        begin: 0.92,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
      child: child,
    ),
  );
}
