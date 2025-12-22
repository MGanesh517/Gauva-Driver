import 'package:dartz/dartz.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/privacy_and_policy_model/privacy_and_policy_model.dart';
import 'package:gauva_driver/data/models/terms_and_condition_model/terms_and_condition_model.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import 'package:gauva_driver/data/repositories/interfaces/terms_and_privacy_repo_interface.dart';

import '../services/terms_and_privacy_service.dart';

class TermsAndPrivacyRepoImpl extends BaseRepository implements ITermsAndPrivacyRepo {
  final TermsAndPrivacyService termsAndPrivacyService;

  TermsAndPrivacyRepoImpl({required this.termsAndPrivacyService});

  @override
  Future<Either<Failure, TermsAndConditionModel>> termsAndCondition() async => await safeApiCall(() async {
    final response = await termsAndPrivacyService.termsAndCondition();
    return TermsAndConditionModel.fromJson(response.data);
  });

  @override
  Future<Either<Failure, PrivacyAndPolicyModel>> privacyAndPolicy() async => await safeApiCall(() async {
    final response = await termsAndPrivacyService.privacyPolicy();
    return PrivacyAndPolicyModel.fromJson(response.data);
  });

  @override
  Future<Either<Failure, String>> rateCard() async => await safeApiCall(() async {
    final response = await termsAndPrivacyService.rateCard();
    // Assuming the API returns the HTML string directly or in a 'data' field.
    // Based on user prompt "html format data will come", it could be:
    // 1. Raw HTML string
    // 2. JSON: { data: "<html>...</html>" }
    // 3. JSON: { data: { content: "<html>...</html>" } }

    // I will try to handle both generic JSON 'data' or raw string
    if (response.data is String) {
      return response.data as String;
    } else if (response.data is Map<String, dynamic>) {
      // If it is like Terms/Privacy models:
      if (response.data['data'] != null) {
        if (response.data['data'] is String) {
          return response.data['data'];
        }
        // If it is structured like { data: { content: "..." } } - guess work here, looking at other models
        // Terms model has data -> terms (String)
        // So let's check keys
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          // Try to find a likely key
          return data['content'] ?? data['html'] ?? data['rate_card'] ?? data.toString();
        }
      }
      return response.data.toString();
    }
    return response.data.toString();
  });
}
