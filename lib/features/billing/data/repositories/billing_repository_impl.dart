import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/features/billing/data/datasources/billing_remote_data_source.dart';
import 'package:mindvibe_app/features/billing/domain/entities/billing_entities.dart';
import 'package:mindvibe_app/features/billing/domain/repositories/billing_repository.dart';

class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl(this._remote);

  final BillingRemoteDataSource _remote;

  @override
  Future<Result<BillingEntitlement>> entitlement() => _remote.entitlement();

  @override
  Future<Result<CheckoutLink>> checkoutLink() => _remote.checkoutLink();

  @override
  Future<Result<CheckoutLink>> createCheckout() => checkoutLink();

  @override
  Future<Result<List<BillingPayment>>> payments() => _remote.payments();
}
