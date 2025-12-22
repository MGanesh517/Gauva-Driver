import 'package:dio/dio.dart';
import 'package:gauva_driver/domain/interfaces/terms_privacy.dart';

import '../../core/config/api_endpoints.dart';
import 'api/dio_client.dart';

class TermsAndPrivacyService implements ITermsAndPrivacy {
  final DioClient dioClient;

  TermsAndPrivacyService({required this.dioClient});
  @override
  Future<Response> termsAndCondition() async => await dioClient.dio.get(ApiEndpoints.termsAndConditions);

  @override
  Future<Response> privacyPolicy() async => await dioClient.dio.get(ApiEndpoints.privacyPolicy);

  @override
  Future<Response> rateCard() async => await dioClient.dio.get(ApiEndpoints.rateCard);
}
