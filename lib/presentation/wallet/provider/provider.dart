import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_balance_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/wallet_repo_interface.dart';
import 'package:gauva_driver/data/repositories/wallets_repo_impl.dart';
import 'package:gauva_driver/data/services/wallet_service.dart';
import 'package:gauva_driver/domain/interfaces/wallet_service_interface.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';
import 'package:gauva_driver/presentation/wallet/view_model/wallets_notifier.dart';

import '../../../core/state/app_state.dart';
import '../../../data/models/my_card_model/my_card_model.dart';
import '../view_model/add_card_notifier.dart';
import '../view_model/delete_card_notifier.dart';
import '../view_model/my_cards_notifier.dart';

// Service Provider
final walletsServiceProvider = Provider<IWalletService>((ref) => WalletService(dioClient: ref.read(dioClientProvider)));

// Repo Provider
final walletsRepoProvider = Provider<IWalletsRepo>(
  (ref) => WalletsRepoImpl(walletService: ref.read(walletsServiceProvider)),
);

final walletsBalanceProvider = StateNotifierProvider<WalletsNotifier, AppState<WalletBalanceModel>>(
  (ref) => WalletsNotifier(walletsRepo: ref.watch(walletsRepoProvider), ref: ref),
);

final withdrawProvider = StateNotifierProvider<WithdrawNotifier, AppState<CommonResponse>>(
  (ref) => WithdrawNotifier(walletsRepo: ref.watch(walletsRepoProvider), ref: ref),
);

final transactionHistoryProvider = StateNotifierProvider<TransactionHistoryNotifier, TransactionHistoryState>(
  (ref) => TransactionHistoryNotifier(walletsRepo: ref.watch(walletsRepoProvider), ref: ref),
);

final myCardsProvider = StateNotifierProvider<MyCardsNotifier, AppState<List<Cards>>>(
  (ref) => MyCardsNotifier(walletsRepo: ref.watch(walletsRepoProvider), ref: ref),
);

final addCardProvider = StateNotifierProvider<AddCardNotifier, AppState<CommonResponse>>(
  (ref) => AddCardNotifier(walletsRepo: ref.watch(walletsRepoProvider), ref: ref),
);

final deleteCardProvider = StateNotifierProvider<DeleteCardNotifier, AppState<CommonResponse>>(
  (ref) => DeleteCardNotifier(walletsRepo: ref.watch(walletsRepoProvider), ref: ref),
);
