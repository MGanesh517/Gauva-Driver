import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_balance_model.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_transaction_history_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/wallet_repo_interface.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/wallet/provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../widgets/withdraw_dialogue.dart';

class WalletsNotifier extends StateNotifier<AppState<WalletBalanceModel>> {
  final IWalletsRepo walletsRepo;
  final Ref ref;

  WalletsNotifier({required this.walletsRepo, required this.ref}) : super(const AppState.initial());

  Future<void> getWalletBalance() async {
    state = const AppState.loading();
    final result = await walletsRepo.getWallets();
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        state = AppState.success(data);
      },
    );
  }
}

class WithdrawNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IWalletsRepo walletsRepo;
  final Ref ref;

  WithdrawNotifier({required this.walletsRepo, required this.ref}) : super(const AppState.initial());

  Future<void> withdraw({required Map<String, dynamic> body, required String amount}) async {
    state = const AppState.loading();
    final result = await walletsRepo.withdraw(body: body);
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        state = AppState.success(data);
        NavigationService.pop();
        showWithdrawRequestSubmitDialog(NavigationService.navigatorKey.currentContext!, amount: amount);
        ref.read(walletsBalanceProvider.notifier).getWalletBalance();
        ref.read(transactionHistoryProvider.notifier).getTransactionHistory();
      },
    );
  }
}

class TransactionHistoryState {
  final AppState<List<Transaction>> transactions;
  final DateTime? dateTime;
  final String? paymentMode;

  const TransactionHistoryState({
    this.transactions = const AppState.success([]),
    this.dateTime,
    this.paymentMode = 'received',
  });

  TransactionHistoryState copyWith({
    AppState<List<Transaction>>? transactions,
    DateTime? dateTime,
    String? paymentMode,
  }) => TransactionHistoryState(
    transactions: transactions ?? this.transactions,
    dateTime: dateTime ?? this.dateTime,
    paymentMode: paymentMode ?? this.paymentMode,
  );
}

class TransactionHistoryNotifier extends StateNotifier<TransactionHistoryState> {
  final IWalletsRepo walletsRepo;
  final Ref ref;

  TransactionHistoryNotifier({required this.walletsRepo, required this.ref}) : super(const TransactionHistoryState());

  // dateTime update method
  void updateDateTime(DateTime? dateTime) {
    state = state.copyWith(dateTime: dateTime);
  }

  // paymentMode update method
  void updatePaymentMode(String? paymentMode) {
    state = state.copyWith(paymentMode: paymentMode);
  }

  Future<void> getTransactionHistory() async {
    // Update loading state but keep other fields as-is
    state = state.copyWith(transactions: const AppState.loading());

    final result = await walletsRepo.getWalletsTransaction(
      dateTime: state.dateTime?.toIso8601String(),
      paymentMode: state.paymentMode,
    );

    result.fold(
      (failure) {
        state = state.copyWith(transactions: AppState.error(failure));
        showNotification(message: failure.message);
      },
      (data) {
        // Extract transactions from the response
        final transactionList = data.data?.transaction ?? [];
        state = state.copyWith(transactions: AppState.success(transactionList));
      },
    );
  }
}
