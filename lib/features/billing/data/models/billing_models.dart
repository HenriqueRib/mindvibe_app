import 'package:mindvibe_app/features/billing/domain/entities/billing_entities.dart';

DateTime? _date(dynamic value) {
  if (value is! String || value.isEmpty) {
    return null;
  }
  return DateTime.tryParse(value);
}

double _amount(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}

BillingEntitlement entitlementFromJson(Map<String, dynamic> json) {
  return BillingEntitlement(
    isPremium: json['is_premium'] as bool? ?? false,
    plan: json['plan'] as String? ?? 'free',
    status: json['status'] as String? ?? 'none',
    canRenew: json['can_renew'] as bool? ?? true,
    checkoutAvailable: json['checkout_available'] as bool? ?? false,
    amount: _amount(json['amount']),
    currency: json['currency'] as String? ?? 'BRL',
    periodDays: json['period_days'] as int? ?? 30,
    startsAt: _date(json['starts_at']),
    endsAt: _date(json['ends_at']),
    renewsAt: _date(json['renews_at']),
    pendingPaymentId: json['pending_payment_id'] as int?,
  );
}

CheckoutLink checkoutLinkFromJson(Map<String, dynamic> json) {
  return CheckoutLink(
    url: json['url'] as String? ?? '',
    paymentId: json['payment_id'] as int? ?? 0,
    hubPaymentId: json['hub_payment_id'] as int?,
    amount: _amount(json['amount']),
    currency: json['currency'] as String? ?? 'BRL',
    periodDays: json['period_days'] as int? ?? 30,
  );
}

BillingPayment paymentFromJson(Map<String, dynamic> json) {
  return BillingPayment(
    id: json['id'] as int,
    planSlug: json['plan_slug'] as String? ?? 'premium',
    amount: _amount(json['amount']),
    currency: json['currency'] as String? ?? 'BRL',
    status: json['status'] as String? ?? 'pending',
    provider: json['provider'] as String?,
    paidAt: _date(json['paid_at']),
    periodStartsAt: _date(json['period_starts_at']),
    periodEndsAt: _date(json['period_ends_at']),
    createdAt: _date(json['created_at']),
  );
}

List<BillingPayment> paymentsFromJson(dynamic data) {
  if (data is! List) {
    return const [];
  }
  return data
      .whereType<Map<String, dynamic>>()
      .map(paymentFromJson)
      .toList();
}
