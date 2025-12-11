import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/utils/helpers.dart';

import '../../../core/state/app_state.dart';
import '../../../data/models/my_card_model/my_card_model.dart';
import '../../../data/repositories/interfaces/wallet_repo_interface.dart';

class MyCardsNotifier extends StateNotifier<AppState<List<Cards>>> {
  final IWalletsRepo walletsRepo;
  final Ref ref;

  MyCardsNotifier({required this.walletsRepo, required this.ref}) : super(const AppState.initial());

  Future<void> myCards() async {
    state = const AppState.loading();
    final result = await walletsRepo.myCards();
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        showNotification(message: data.message, isSuccess: true);
        state = AppState.success(data.data?.cards ?? []);
      },
    );
  }
}
