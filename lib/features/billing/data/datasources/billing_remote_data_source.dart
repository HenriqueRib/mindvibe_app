import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/network/api_client.dart';
import 'package:mindvibe_app/features/billing/data/models/billing_models.dart';
import 'package:mindvibe_app/features/billing/domain/entities/billing_entities.dart';

class BillingRemoteDataSource {
  BillingRemoteDataSource(this._client);

  final ApiClient _client;

  Future<Result<BillingEntitlement>> entitlement() {
    return _client.get(
      '/billing/entitlement',
      parse: (data) => entitlementFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<CheckoutLink>> checkoutLink() {
    return _client.post(
      '/billing/checkout-link',
      parse: (data) => checkoutLinkFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<List<BillingPayment>>> payments() {
    return _client.get(
      '/billing/payments',
      parse: paymentsFromJson,
    );
  }
}
