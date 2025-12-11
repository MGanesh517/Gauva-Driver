import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_balance_model.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_transaction_history_model.dart';
import 'package:gauva_driver/data/models/wallet_model/payment_transaction_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/wallet_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/wallet_service_interface.dart';
import '../../core/errors/failure.dart';
import '../models/my_card_model/my_card_model.dart';
import 'base_repository.dart';

class WalletsRepoImpl extends BaseRepository implements IWalletsRepo {
  final IWalletService walletService;

  WalletsRepoImpl({required this.walletService});
  @override
  Future<Either<Failure, WalletBalanceModel>> getWallets() async => await safeApiCall(() async {
    final response = await walletService.getWallets();
    return WalletBalanceModel.fromJson(response.data);
  });

  @override
  Future<Either<Failure, WalletTransactionHistoryModel>> getWalletsTransaction({
    String? dateTime,
    String? paymentMode,
  }) async => await safeApiCall(() async {
    final response = await walletService.getWalletsTransaction(dateTime: dateTime, paymentMode: paymentMode);

    // Parse new payment transactions response
    final paymentResponse = PaymentTransactionResponse.fromJson(response.data);

    // Convert PaymentTransaction list to Transaction list for backward compatibility
    final transactions =
        paymentResponse.content?.map((paymentTx) {
          return Transaction(
            id: paymentTx.id,
            orderId: paymentTx.rideId,
            driverId: paymentTx.driverId,
            amount: paymentTx.amount,
            method: paymentTx.provider,
            paymentMode: paymentTx.type,
            createdAt: paymentTx.createdAt,
            transaction: _determineTransactionType(paymentTx.type, paymentTx.status),
            notes: paymentTx.notes,
            status: paymentTx.status,
            type: paymentTx.type,
            currency: paymentTx.currency,
            provider: paymentTx.provider,
          );
        }).toList() ??
        [];

    // Create WalletTransactionHistoryModel with converted transactions
    return WalletTransactionHistoryModel(data: WalletTransactionHistoryModelData(transaction: transactions));
  });

  /// Helper to determine transaction type (credit/debit) from payment type and status
  String _determineTransactionType(String? type, String? status) {
    if (type == null) return 'debit';

    // WALLET_TOPUP, PAYMENT, etc. - typically credits
    if (type.toUpperCase().contains('TOPUP') ||
        type.toUpperCase().contains('PAYMENT') ||
        type.toUpperCase().contains('CREDIT')) {
      return status == 'COMPLETED' || status == 'SUCCESS' || status == 'PENDING' ? 'credit' : 'pending';
    }

    // WITHDRAW, REFUND, etc. - typically debits
    if (type.toUpperCase().contains('WITHDRAW') ||
        type.toUpperCase().contains('REFUND') ||
        type.toUpperCase().contains('DEBIT')) {
      return 'debit';
    }

    return 'debit';
  }

  @override
  Future<Either<Failure, CommonResponse>> withdraw({required Map<String, dynamic> body}) async =>
      await safeApiCall(() async {
        final response = await walletService.withdraw(body: body);
        return CommonResponse.fromJson(response.data);
      });

  @override
  Future<Either<Failure, CommonResponse>> addCard({required Map<String, dynamic> body}) async =>
      await safeApiCall(() async {
        final response = await walletService.addCard(body: body);
        return CommonResponse.fromJson(response.data);
      });

  @override
  Future<Either<Failure, MyCardModel>> myCards() async => await safeApiCall(() async {
    final response = await walletService.myCards();
    return MyCardModel.fromJson(response.data);
  });

  @override
  Future<Either<Failure, CommonResponse>> deleteCard({required String? id}) async => await safeApiCall(() async {
    final response = await walletService.deleteCard(id);
    return CommonResponse.fromJson(response.data);
  });
}
