import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/billing/domain/entities/billing_entities.dart';
import 'package:mindvibe_app/features/billing/presentation/providers/billing_providers.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class BillingPage extends ConsumerStatefulWidget {
  const BillingPage({super.key});

  @override
  ConsumerState<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends ConsumerState<BillingPage>
    with WidgetsBindingObserver {
  bool _opening = false;

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
      ref.invalidate(billingEntitlementProvider);
      ref.invalidate(billingPaymentsProvider);
      ref.read(sessionControllerProvider.notifier).refreshProfile();
      ref.invalidate(todayProvider);
    }
  }

  Future<void> _renew() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _opening = true);
    final result = await ref.read(billingRepositoryProvider).createCheckout();
    if (!mounted) {
      return;
    }
    setState(() => _opening = false);
    final checkout = result.valueOrNull;
    if (checkout == null) {
      _toast(failureMessage(result.failureOrNull!, l10n));
      return;
    }
    final uri = Uri.tryParse(checkout.url);
    if (uri == null) {
      _toast(l10n.paywallOpenError);
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _toast(l10n.paywallOpenError);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entitlement = ref.watch(billingEntitlementProvider);
    final payments = ref.watch(billingPaymentsProvider);
    final isPremium =
        ref.watch(sessionControllerProvider).user?.isPremium == true;

    return AppScaffold(
      showBack: true,
      title: l10n.billingTitle,
      body: ListView(
        children: [
          entitlement.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: AppLoading.compact(),
            ),
            error: (_, _) => AppError(
              title: l10n.errorLoadTitle,
              message: l10n.errorGeneric,
              retryLabel: l10n.actionRetry,
              onRetry: () => ref.invalidate(billingEntitlementProvider),
            ),
            data: (result) => result.when(
              failure: (failure) => AppError(
                title: l10n.errorLoadTitle,
                message: failureMessage(failure, l10n),
                retryLabel: l10n.actionRetry,
                onRetry: () => ref.invalidate(billingEntitlementProvider),
              ),
              success: (data) => _StatusCard(
                entitlement: data,
                isPremium: isPremium,
                opening: _opening,
                onRenew: data.checkoutAvailable ? _renew : null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppText.title(l10n.billingHistoryTitle),
          const SizedBox(height: 12),
          payments.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: AppLoading.compact(),
            ),
            error: (_, _) => AppError(
              title: l10n.errorLoadTitle,
              message: l10n.errorGeneric,
              retryLabel: l10n.actionRetry,
              onRetry: () => ref.invalidate(billingPaymentsProvider),
            ),
            data: (result) => result.when(
              failure: (failure) => AppError(
                title: l10n.errorLoadTitle,
                message: failureMessage(failure, l10n),
                retryLabel: l10n.actionRetry,
                onRetry: () => ref.invalidate(billingPaymentsProvider),
              ),
              success: (items) {
                if (items.isEmpty) {
                  return AppEmpty(
                    title: l10n.emptyTitle,
                    body: l10n.billingHistoryEmpty,
                    icon: Icons.receipt_long_outlined,
                  );
                }
                return Column(
                  children: [
                    for (final item in items) ...[
                      _PaymentTile(payment: item),
                      const SizedBox(height: 8),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.entitlement,
    required this.isPremium,
    required this.opening,
    required this.onRenew,
  });

  final BillingEntitlement entitlement;
  final bool isPremium;
  final bool opening;
  final VoidCallback? onRenew;

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
    final statusLabel = switch (entitlement.status) {
      'active' => l10n.billingStatusActive,
      'pending' => l10n.billingStatusPending,
      'failed' => l10n.billingStatusFailed,
      'expired' => l10n.billingStatusExpired,
      _ => l10n.billingStatusNone,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPremium ? l10n.profilePlanPremium : l10n.profilePlanFree,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(statusLabel),
          if (entitlement.endsAt != null) ...[
            const SizedBox(height: 6),
            Text(
              l10n.billingValidUntil(
                DateFormat.yMMMd(l10n.localeName).format(entitlement.endsAt!),
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(l10n.paywallPriceHint(price, period)),
          const SizedBox(height: 16),
          AppButton(
            label: isPremium ? l10n.paywallCtaRenew : l10n.paywallCta,
            loading: opening,
            onPressed: onRenew,
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment});

  final BillingPayment payment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final price = NumberFormat.simpleCurrency(
      locale: l10n.localeName,
      name: payment.currency,
    ).format(payment.amount);
    final when = payment.paidAt ?? payment.createdAt;
    final status = switch (payment.status) {
      'approved' => l10n.billingPaymentApproved,
      'pending' => l10n.billingPaymentPending,
      'failed' => l10n.billingPaymentFailed,
      'refunded' => l10n.billingPaymentRefunded,
      _ => payment.status,
    };

    return AppCard(
      child: Row(
        children: [
          Icon(
            payment.status == 'approved'
                ? Icons.check_circle_outline_rounded
                : Icons.receipt_long_outlined,
            color: payment.status == 'approved'
                ? AppColors.success
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  when == null
                      ? status
                      : '$status · ${DateFormat.yMMMd(l10n.localeName).format(when)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
