import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/repositories/interfaces/terms_and_privacy_repo_interface.dart';

class RateCardNotifier extends StateNotifier<AppState<String>> {
  final ITermsAndPrivacyRepo _repo;
  final Ref ref;

  RateCardNotifier({required ITermsAndPrivacyRepo repo, required this.ref})
    : _repo = repo,
      super(const AppState.initial());

  Future<void> getRateCard() async {
    state = const AppState.loading();
    final result = await _repo.rateCard();

    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        state = AppState.success(data);
      },
    );
  }
}
