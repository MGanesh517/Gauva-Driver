import 'package:dio/dio.dart';
import 'package:gauva_driver/domain/interfaces/delete_account_service.dart';

import '../../core/config/api_endpoints.dart';
import 'api/dio_client.dart';

class DeleteAccountService implements IDeleteAccountService {
  final DioClient dioClient;

  DeleteAccountService({required this.dioClient});
  @override
  Future<Response> deleteAccount() async => await dioClient.dio.delete(ApiEndpoints.deleteAccount);
}
