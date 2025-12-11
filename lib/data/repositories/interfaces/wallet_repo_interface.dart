import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_balance_model.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_transaction_history_model.dart';
import '../../../core/errors/failure.dart';
import '../../models/my_card_model/my_card_model.dart';

abstract class IWalletsRepo {
  Future<Either<Failure, WalletBalanceModel>> getWallets();
  Future<Either<Failure, WalletTransactionHistoryModel>> getWalletsTransaction({String? dateTime, String? paymentMode});
  Future<Either<Failure, CommonResponse>> withdraw({required Map<String, dynamic> body});
  Future<Either<Failure, MyCardModel>> myCards();
  Future<Either<Failure, CommonResponse>> addCard({required Map<String, dynamic> body});
  Future<Either<Failure, CommonResponse>> deleteCard({required String? id});
}
