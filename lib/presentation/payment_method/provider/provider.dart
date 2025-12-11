import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/models/payment_methods_model/payment_methods_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/payment_methods_repo_interface.dart';
import 'package:gauva_driver/data/repositories/payment_methods_repo_impl.dart';
import 'package:gauva_driver/data/services/payment_method_service.dart';
import 'package:gauva_driver/domain/interfaces/payment_method_service_interface.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';
import 'package:gauva_driver/presentation/payment_method/view_model/payment_method_notifier.dart';

import '../../../core/state/app_state.dart';

// Service Provider
final paymentMethodServiceProvider = Provider<IPaymentMethodsService>(
  (ref) => PaymentMethodService(dioClient: ref.read(dioClientChattingProvider)),
);

// Repo Provider
final paymentMethodsRepoProvider = Provider<IPaymentMethodsRepo>(
  (ref) => PaymentMethodsRepoImpl(paymentMethodsService: ref.read(paymentMethodServiceProvider)),
);

final paymentMethodsNotifierProvider = StateNotifierProvider<PaymentMethodNotifier, AppState<List<PaymentMethods>>>(
  (ref) => PaymentMethodNotifier(paymentMethodsRepo: ref.watch(paymentMethodsRepoProvider), ref: ref),
);

final selectedPayMethodProvider = StateNotifierProvider<SelectedPaymentMethodNotifier, PaymentMethods?>(
  (ref) => SelectedPaymentMethodNotifier(ref: ref),
);
