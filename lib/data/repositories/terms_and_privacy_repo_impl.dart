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

    if (response.data is Map<String, dynamic>) {
      final map = response.data as Map<String, dynamic>;

      // Check for content directly in the root
      if (map['content'] != null) {
        return map['content'].toString();
      }

      // Check for nested 'data' object
      if (map['data'] != null) {
        final innerData = map['data'];
        if (innerData is Map<String, dynamic>) {
          return innerData['content']?.toString() ?? innerData['html']?.toString() ?? innerData.toString();
        }
        if (innerData is String) {
          return innerData;
        }
      }
    }

    if (response.data is String) {
      return response.data as String;
    }

    return response.data.toString();
  });
}
