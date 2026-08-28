import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/billing/domain/entities/billing_entities.dart';
import 'package:mindvibe_app/features/billing/presentation/providers/billing_providers.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PaywallPage extends ConsumerStatefulWidget {
  const PaywallPage({super.key});

  @override
  ConsumerState<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends ConsumerState<PaywallPage>
    with WidgetsBindingObserver {
  bool _opening = false;
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAfterCheckout();
    }
  }

  Future<void> _refreshAfterCheckout() async {
    ref.invalidate(billingEntitlementProvider);
    await ref.read(sessionControllerProvider.notifier).refreshProfile();
    ref.invalidate(todayProvider);
    if (!mounted) {
      return;
    }
    final user = ref.read(sessionControllerProvider).user;
    if (user?.isPremium == true && mounted) {
      setState(() => _waiting = false);
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  Future<void> _subscribe() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _opening = true);
    final result = await ref.read(billingRepositoryProvider).createCheckout();
    if (!mounted) {
      return;
    }
    setState(() => _opening = false);
    final checkout = result.valueOrNull;
    if (checkout == null) {
      _showError(failureMessage(result.failureOrNull!, l10n));
      return;
    }
    final uri = Uri.tryParse(checkout.url);
    if (uri == null) {
      _showError(l10n.paywallOpenError);
      return;
    }
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      _showError(l10n.paywallOpenError);
      return;
    }
    if (mounted) {
      setState(() => _waiting = true);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entitlement = ref.watch(billingEntitlementProvider);
    final user = ref.watch(sessionControllerProvider).user;
    final isPremium = user?.isPremium == true;

    return AppScaffold(
      showBack: true,
      title: l10n.paywallTitle,
      body: entitlement.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(billingEntitlementProvider),
        ),
        data: (result) => result.when(
          failure: (failure) => AppError(
            message: failureMessage(failure, l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.invalidate(billingEntitlementProvider),
          ),
          success: (data) => _PaywallBody(
            entitlement: data,
            isPremium: isPremium,
            opening: _opening,
            waiting: _waiting,
            onSubscribe: data.checkoutAvailable ? _subscribe : null,
            onOpenHistory: () => context.push(AppRoutes.billing),
          ),
        ),
      ),
    );
  }
}

class _PaywallBody extends StatelessWidget {
  const _PaywallBody({
    required this.entitlement,
    required this.isPremium,
    required this.opening,
    required this.waiting,
    required this.onSubscribe,
    required this.onOpenHistory,
  });

  final BillingEntitlement entitlement;
  final bool isPremium;
  final bool opening;
  final bool waiting;
  final VoidCallback? onSubscribe;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final price = NumberFormat.simpleCurrency(
      locale: l10n.localeName,
      name: entitlement.currency,
    ).format(entitlement.amount);
    final period = entitlement.periodDays == 30
        ? l10n.billingPeriodMonth
        : l10n.billingPeriodDays(entitlement.periodDays);
    final cta = isPremium
        ? l10n.paywallCtaRenew
        : l10n.paywallCtaPrice(price, period);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.title(l10n.paywallTitle),
        const SizedBox(height: 12),
        AppText.subtitle(l10n.paywallBody),
        const SizedBox(height: 16),
        Text(
          l10n.paywallPriceHint(price, period),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        if (entitlement.endsAt != null) ...[
          const SizedBox(height: 8),
          Text(
            l10n.billingValidUntil(
              DateFormat.yMMMd(l10n.localeName).format(entitlement.endsAt!),
            ),
          ),
        ],
        const SizedBox(height: 28),
        _PaywallBlock(
          icon: Icons.check_circle_outline_rounded,
          label: l10n.paywallFreeLabel,
          body: l10n.paywallFreeList,
          accent: AppColors.success,
        ),
        const SizedBox(height: 12),
        _PaywallBlock(
          icon: Icons.lock_outline_rounded,
          label: l10n.paywallPremiumLabel,
          body: l10n.paywallPremiumList,
          accent: AppColors.primary,
        ),
        if (waiting) ...[
          const SizedBox(height: 16),
          Text(l10n.paywallWaiting),
        ],
        const Spacer(),
        TextButton(
          onPressed: onOpenHistory,
          child: Text(l10n.billingHistoryTitle),
        ),
        AppButton(
          label: onSubscribe == null ? l10n.paywallCtaSoon : cta,
          loading: opening,
          onPressed: onSubscribe,
        ),
      ],
    );
  }
}

class _PaywallBlock extends StatelessWidget {
  const _PaywallBlock({
    required this.icon,
    required this.label,
    required this.body,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
