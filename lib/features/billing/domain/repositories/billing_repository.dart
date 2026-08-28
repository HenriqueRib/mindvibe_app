import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/features/billing/domain/entities/billing_entities.dart';

abstract class BillingRepository {
  Future<Result<BillingEntitlement>> entitlement();

  Future<Result<CheckoutLink>> checkoutLink();

  Future<Result<CheckoutLink>> createCheckout();

  Future<Result<List<BillingPayment>>> payments();
}
