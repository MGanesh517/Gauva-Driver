import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/presentation/wallet/provider/provider.dart';

import '../../../core/state/app_state.dart';
import '../../../data/repositories/interfaces/wallet_repo_interface.dart';

class DeleteCardNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IWalletsRepo walletsRepo;
  final Ref ref;

  DeleteCardNotifier({required this.walletsRepo, required this.ref}) : super(const AppState.initial());

  String? deletingCardId;

  Future<void> deleteCard({required String? id}) async {
    deletingCardId = id;

    state = const AppState.loading();
    final result = await walletsRepo.deleteCard(id: id);
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        showNotification(message: data.message, isSuccess: true);
        ref.read(myCardsProvider.notifier).myCards();
        state = AppState.success(data);
      },
    );
  }
}
