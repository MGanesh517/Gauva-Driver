import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/privacy_and_policy_model/privacy_and_policy_model.dart';
import 'package:gauva_driver/data/models/terms_and_condition_model/terms_and_condition_model.dart';

import '../../../core/errors/failure.dart';

abstract class ITermsAndPrivacyRepo {
  Future<Either<Failure, TermsAndConditionModel>> termsAndCondition();
  Future<Either<Failure, PrivacyAndPolicyModel>> privacyAndPolicy();
}
