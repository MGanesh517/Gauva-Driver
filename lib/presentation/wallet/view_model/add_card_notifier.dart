import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/wallet/provider/provider.dart';

import '../../../core/state/app_state.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/common_response.dart';
import '../../../data/repositories/interfaces/wallet_repo_interface.dart';

class AddCardNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IWalletsRepo walletsRepo;
  final Ref ref;

  AddCardNotifier({required this.walletsRepo, required this.ref}) : super(const AppState.initial());

  Future<void> addCard({required Map<String, dynamic> body}) async {
    state = const AppState.loading();
    final result = await walletsRepo.addCard(body: body);
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        state = AppState.success(data);

        ref.read(myCardsProvider.notifier).myCards();
        NavigationService.pop();
      },
    );
  }
}
