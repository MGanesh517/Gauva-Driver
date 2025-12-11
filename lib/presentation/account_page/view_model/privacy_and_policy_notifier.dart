import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/models/privacy_and_policy_model/privacy_and_policy_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/terms_and_privacy_repo_interface.dart';

import '../../../core/state/app_state.dart';
import '../../../core/utils/helpers.dart';

class PrivacyAndPolicyNotifier extends StateNotifier<AppState<PrivacyAndPolicyModel>> {
  final ITermsAndPrivacyRepo _termsAndConditionRepo;
  final Ref ref;
  PrivacyAndPolicyNotifier({required ITermsAndPrivacyRepo termsAndConditionRepo, required this.ref})
    : _termsAndConditionRepo = termsAndConditionRepo,
      super(const AppState.initial());

  Future<void> privacyPolicy() async {
    state = const AppState.loading();
    final result = await _termsAndConditionRepo.privacyAndPolicy();

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
