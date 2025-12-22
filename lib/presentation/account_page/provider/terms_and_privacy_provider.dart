import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/models/privacy_and_policy_model/privacy_and_policy_model.dart';
import 'package:gauva_driver/data/models/terms_and_condition_model/terms_and_condition_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/terms_and_privacy_repo_interface.dart';
import 'package:gauva_driver/data/repositories/terms_and_privacy_repo_impl.dart';
import 'package:gauva_driver/data/services/terms_and_privacy_service.dart';
import 'package:gauva_driver/presentation/account_page/view_model/privacy_and_policy_notifier.dart';
import 'package:gauva_driver/presentation/account_page/view_model/terms_and_condition_notifier.dart';
import 'package:gauva_driver/presentation/account_page/view_model/rate_card_notifier.dart';

import '../../../core/state/app_state.dart';
import '../../auth/provider/auth_providers.dart';

final termsAndPrivacyServiceProvider = Provider<TermsAndPrivacyService>(
  (ref) => TermsAndPrivacyService(dioClient: ref.read(dioClientProvider)),
);

// Repo Provider
final termsAndPrivacyRepoProvider = Provider<ITermsAndPrivacyRepo>(
  (ref) => TermsAndPrivacyRepoImpl(termsAndPrivacyService: ref.read(termsAndPrivacyServiceProvider)),
);

// View Model Providers
final termsAndConditionProvider = StateNotifierProvider<TermsAndConditionNotifier, AppState<TermsAndConditionModel>>(
  (ref) => TermsAndConditionNotifier(ref: ref, termsAndConditionRepo: ref.read(termsAndPrivacyRepoProvider)),
);

final privacyAndPolicyProvider = StateNotifierProvider<PrivacyAndPolicyNotifier, AppState<PrivacyAndPolicyModel>>(
  (ref) => PrivacyAndPolicyNotifier(ref: ref, termsAndConditionRepo: ref.read(termsAndPrivacyRepoProvider)),
);

final rateCardProvider = StateNotifierProvider<RateCardNotifier, AppState<String>>(
  (ref) => RateCardNotifier(ref: ref, repo: ref.read(termsAndPrivacyRepoProvider)),
);
