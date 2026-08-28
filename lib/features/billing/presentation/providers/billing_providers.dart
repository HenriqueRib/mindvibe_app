import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/billing/data/datasources/billing_remote_data_source.dart';
import 'package:mindvibe_app/features/billing/data/repositories/billing_repository_impl.dart';
import 'package:mindvibe_app/features/billing/domain/entities/billing_entities.dart';
import 'package:mindvibe_app/features/billing/domain/repositories/billing_repository.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepositoryImpl(
    BillingRemoteDataSource(ref.watch(apiClientProvider)),
  );
});

final billingEntitlementProvider =
    FutureProvider.autoDispose<Result<BillingEntitlement>>((ref) {
      return ref.watch(billingRepositoryProvider).entitlement();
    });

final billingPaymentsProvider =
    FutureProvider.autoDispose<Result<List<BillingPayment>>>((ref) {
      return ref.watch(billingRepositoryProvider).payments();
    });
