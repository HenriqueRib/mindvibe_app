class BillingEntitlement {
  const BillingEntitlement({
    required this.isPremium,
    required this.plan,
    required this.status,
    required this.canRenew,
    required this.checkoutAvailable,
    required this.amount,
    required this.currency,
    required this.periodDays,
    this.startsAt,
    this.endsAt,
    this.renewsAt,
    this.pendingPaymentId,
  });

  final bool isPremium;
  final String plan;
  final String status;
  final bool canRenew;
  final bool checkoutAvailable;
  final double amount;
  final String currency;
  final int periodDays;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? renewsAt;
  final int? pendingPaymentId;
}

class CheckoutLink {
  const CheckoutLink({
    required this.url,
    required this.paymentId,
    required this.amount,
    required this.currency,
    required this.periodDays,
    this.hubPaymentId,
  });

  final String url;
  final int paymentId;
  final int? hubPaymentId;
  final double amount;
  final String currency;
  final int periodDays;
}

class BillingPayment {
  const BillingPayment({
    required this.id,
    required this.planSlug,
    required this.amount,
    required this.currency,
    required this.status,
    this.provider,
    this.paidAt,
    this.periodStartsAt,
    this.periodEndsAt,
    this.createdAt,
  });

  final int id;
  final String planSlug;
  final double amount;
  final String currency;
  final String status;
  final String? provider;
  final DateTime? paidAt;
  final DateTime? periodStartsAt;
  final DateTime? periodEndsAt;
  final DateTime? createdAt;
}
