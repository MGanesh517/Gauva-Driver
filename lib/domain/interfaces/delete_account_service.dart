import 'package:dio/dio.dart';

abstract class IDeleteAccountService {
  Future<Response> deleteAccount();
}
