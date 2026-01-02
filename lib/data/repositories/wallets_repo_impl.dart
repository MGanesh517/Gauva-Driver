import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_balance_model.dart' as WalletBalance;
import 'package:gauva_driver/data/models/wallet_model/wallet_transaction_history_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/wallet_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/wallet_service_interface.dart';
import '../../core/errors/failure.dart';
import '../models/my_card_model/my_card_model.dart';
import 'base_repository.dart';

class WalletsRepoImpl extends BaseRepository implements IWalletsRepo {
  final IWalletService walletService;

  WalletsRepoImpl({required this.walletService});
  @override
  Future<Either<Failure, WalletBalance.WalletBalanceModel>> getWallets() async => await safeApiCall(() async {
    final response = await walletService.getWallets();
    // New API returns flat JSON: {"balance": 0, ...}
    // Map it to existing model structure
    final data = response.data;
    final balance = data['balance'] ?? 0;

    return WalletBalance.WalletBalanceModel(
      message: 'Success',
      data: WalletBalance.Data(
        wallet: balance,
        paymentWithdraw: 0, // Not provided in new API
        paymentHistory: 0, // Not provided in new API
      ),
    );
  });

  @override
  Future<Either<Failure, WalletTransactionHistoryModel>> getWalletsTransaction({
    String? dateTime,
    String? paymentMode,
  }) async => await safeApiCall(() async {
    final response = await walletService.getWalletsTransaction(dateTime: dateTime, paymentMode: paymentMode);

    final data = response.data;
    List<Transaction> transactions = [];

    if (data is List) {
      transactions = data.map((json) {
        return Transaction(
          id: json['id'],
          orderId: json['referenceId'] != null ? num.tryParse(json['referenceId'].toString()) : null,
          amount: json['amount'],
          status: json['status'],
          type: json['type'],
          createdAt: json['createdAt'],
          notes: json['notes'],
          currency: json['currency'],
          transaction: _determineTransactionType(json['type'], json['status']),
          paymentMode: json['type'],
          method: json['referenceType'], // Use referenceType as method equivalent
        );
      }).toList();
    }

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
