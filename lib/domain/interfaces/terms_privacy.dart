import 'package:dio/dio.dart';

abstract class ITermsAndPrivacy {
  Future<Response> termsAndCondition();
  Future<Response> privacyPolicy();
}
