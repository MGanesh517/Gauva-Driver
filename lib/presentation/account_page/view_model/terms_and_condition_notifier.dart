import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/models/terms_and_condition_model/terms_and_condition_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/terms_and_privacy_repo_interface.dart';

import '../../../core/state/app_state.dart';
import '../../../core/utils/helpers.dart';

class TermsAndConditionNotifier extends StateNotifier<AppState<TermsAndConditionModel>> {
  final ITermsAndPrivacyRepo _termsAndConditionRepo;
  final Ref ref;
  TermsAndConditionNotifier({required ITermsAndPrivacyRepo termsAndConditionRepo, required this.ref})
    : _termsAndConditionRepo = termsAndConditionRepo,
      super(const AppState.initial());

  Future<void> termsAndCondition() async {
    state = const AppState.loading();
    final result = await _termsAndConditionRepo.termsAndCondition();

    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) async {
        state = AppState.success(data);
      },
    );
  }
}
