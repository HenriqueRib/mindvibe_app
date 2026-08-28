import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/timer_ring.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

enum _ClearMindStep { intro, pause, dump, pick, done }

class ClearMindPage extends ConsumerStatefulWidget {
  const ClearMindPage({super.key});

  @override
  ConsumerState<ClearMindPage> createState() => _ClearMindPageState();
}

class _ClearMindPageState extends ConsumerState<ClearMindPage> {
  static const _pauseTotal = 90;
  static const _maxItems = 8;

  var _step = _ClearMindStep.intro;
  var _remaining = _pauseTotal;
  var _pauseElapsed = 0;
  var _saving = false;
  String? _error;
  int? _focusIndex;
  ClearMindResult? _result;
  Timer? _timer;
  final _lines = List.generate(3, (_) => TextEditingController());

  @override
  void dispose() {
    _timer?.cancel();
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  List<String> get _items {
    return [
      for (final line in _lines)
        if (line.text.trim().isNotEmpty) line.text.trim(),
    ];
  }

  void _go(_ClearMindStep step) {
    _timer?.cancel();
    setState(() {
      _step = step;
      _error = null;
    });
  }

  void _startPause() {
    _timer?.cancel();
    setState(() {
      _step = _ClearMindStep.pause;
      _remaining = _pauseTotal;
      _pauseElapsed = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      if (_remaining <= 1) {
        _timer?.cancel();
        _pauseElapsed = _pauseTotal;
        _go(_ClearMindStep.dump);
        return;
      }
      setState(() {
        _remaining -= 1;
        _pauseElapsed += 1;
      });
    });
  }

  Future<void> _submit() async {
    final items = _items;
    final focus = _focusIndex;
    if (_saving || focus == null || focus < 0 || focus >= items.length) {
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final result = await ref
        .read(trainingRepositoryProvider)
        .recordClearMind(
          items: items,
          focusIndex: focus,
          pauseSeconds: _pauseElapsed,
        );
    if (!mounted) {
      return;
    }
    result.when(
      success: (value) {
        HapticFeedback.mediumImpact();
        ref.invalidate(progressProvider);
        ref.invalidate(historyProvider);
        setState(() {
          _saving = false;
          _result = value;
          _step = _ClearMindStep.done;
        });
      },
      failure: (error) {
        setState(() {
          _saving = false;
          _error = failureMessage(error, AppLocalizations.of(context));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final night = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      showBack: true,
      title: l10n.clearMindTitle,
      backgroundColor: night ? AppColors.nightBackground : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: switch (_step) {
          _ClearMindStep.intro => _intro(l10n),
          _ClearMindStep.pause => _pause(l10n, night),
          _ClearMindStep.dump => _dump(l10n),
          _ClearMindStep.pick => _pick(l10n),
          _ClearMindStep.done => _done(l10n),
        },
      ),
    );
  }

  Widget _intro(AppLocalizations l10n) {
    return Column(
      key: const ValueKey('intro'),
      children: [
        const Spacer(),
        AppText.title(l10n.clearMindTitle, align: TextAlign.center),
        const SizedBox(height: 16),
        AppText.subtitle(l10n.clearMindIntro, align: TextAlign.center),
        const Spacer(),
        AppButton(label: l10n.clearMindStart, onPressed: _startPause),
      ],
    );
  }

  Widget _pause(AppLocalizations l10n, bool night) {
    return Column(
      key: const ValueKey('pause'),
      children: [
        AppText.subtitle(l10n.clearMindPauseBody, align: TextAlign.center),
        const Spacer(),
        TimerRing(
          progress: 1 - (_remaining / _pauseTotal),
          color: AppColors.primary,
          track: night ? AppColors.nightSurface : AppColors.surfaceMuted,
          child: Text(
            '$_remaining',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const Spacer(),
        AppButton(
          label: l10n.clearMindSkipPause,
          variant: AppButtonVariant.ghost,
          onPressed: () => _go(_ClearMindStep.dump),
        ),
      ],
    );
  }

  Widget _dump(AppLocalizations l10n) {
    return ListView(
      key: const ValueKey('dump'),
      children: [
        AppText.subtitle(l10n.clearMindDumpBody, align: TextAlign.center),
        const SizedBox(height: 20),
        for (var i = 0; i < _lines.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          TextField(
            controller: _lines[i],
            maxLength: 280,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              counterText: '',
              hintText: l10n.clearMindDumpHint,
            ),
          ),
        ],
        if (_lines.length < _maxItems) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                setState(() => _lines.add(TextEditingController()));
              },
              child: Text(l10n.clearMindAdd),
            ),
          ),
        ],
        const SizedBox(height: 20),
        AppButton(
          label: l10n.clearMindDumpNext,
          onPressed: _items.isEmpty
              ? null
              : () {
                  _focusIndex = null;
                  _go(_ClearMindStep.pick);
                },
        ),
      ],
    );
  }

  Widget _pick(AppLocalizations l10n) {
    final items = _items;
    return ListView(
      key: const ValueKey('pick'),
      children: [
        Text(
          l10n.clearMindQuestion,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.clearMindPickHint,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, height: 1.4),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          AppCard(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _focusIndex = i);
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    items[i],
                    style: TextStyle(
                      fontWeight: _focusIndex == i
                          ? FontWeight.w700
                          : FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
                if (_focusIndex == i)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
              ],
            ),
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error),
          ),
        ],
        const SizedBox(height: 24),
        AppButton(
          label: l10n.clearMindKeepOne,
          loading: _saving,
          onPressed: _focusIndex == null || _saving ? null : _submit,
        ),
      ],
    );
  }

  Widget _done(AppLocalizations l10n) {
    final focus = _result?.today;
    final parked = _result?.parkedCount ?? 0;
    final premium = isPremiumAccount(ref.watch(sessionControllerProvider).user);
    return ListView(
      key: const ValueKey('done'),
      children: [
        Text(
          l10n.clearMindDoneEyebrow.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          focus?.body ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          parked <= 0 ? l10n.clearMindParkedNone : l10n.clearMindParked(parked),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, height: 1.4),
        ),
        const SizedBox(height: 32),
        AppButton(label: l10n.clearMindDone, onPressed: () => context.pop()),
        if (parked > 0) ...[
          const SizedBox(height: 10),
          AppButton(
            label: l10n.clearMindSeeLot,
            variant: AppButtonVariant.secondary,
            onPressed: () => openMaybePremium(
              context,
              isPremium: premium,
              action: () => context.push(AppRoutes.thoughts),
            ),
          ),
        ],
        const SizedBox(height: 10),
        AppButton(
          label: l10n.clearMindOneThing,
          variant: AppButtonVariant.ghost,
          onPressed: () => openMaybePremium(
            context,
            isPremium: premium,
            action: () => context.push(AppRoutes.pomodoro),
          ),
        ),
      ],
    );
  }
}
