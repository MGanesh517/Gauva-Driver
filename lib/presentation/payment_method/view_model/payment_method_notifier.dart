import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/models/payment_methods_model/payment_methods_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/payment_methods_repo_interface.dart';
import 'package:gauva_driver/presentation/payment_method/provider/provider.dart';
import '../../../core/state/app_state.dart';

class PaymentMethodNotifier extends StateNotifier<AppState<List<PaymentMethods>>> {
  final IPaymentMethodsRepo paymentMethodsRepo;
  final Ref ref;

  PaymentMethodNotifier({required this.paymentMethodsRepo, required this.ref}) : super(const AppState.initial());

  Future<void> getPaymentMethods() async {
    ref.read(selectedPayMethodProvider.notifier).reset();
    state = const AppState.loading();
    final result = await paymentMethodsRepo.getPaymentMethods();
    result.fold(
      (failure) => state = AppState.error(failure),
      (data) => state = AppState.success(data.data?.paymentMethods ?? []),
    );
  }
}

class SelectedPaymentMethodNotifier extends StateNotifier<PaymentMethods?> {
  final Ref ref;
  SelectedPaymentMethodNotifier({required this.ref}) : super(null);

  void selectPaymentMethod(PaymentMethods method) {
    state = method;
  }

  void reset() {
    state = null;
  }
}
