import 'package:dio/dio.dart';
import 'package:gauva_driver/domain/interfaces/wallet_service_interface.dart';
import '../../core/config/api_endpoints.dart';
import 'api/dio_client.dart';

class WalletService implements IWalletService {
  final DioClient dioClient;

  WalletService({required this.dioClient});

  @override
  Future<Response> getWallets() async => await dioClient.dio.get(ApiEndpoints.walletBalance);

  @override
  Future<Response> getWalletsTransaction({String? dateTime, String? paymentMode}) async {
    final queryParams = <String, dynamic>{};
    if (dateTime != null) {
      queryParams['date'] = dateTime;
    }
    // paymentMode might not be supported in new API, but keeping logic if applicable or just ignored
    // queryParams['paymentMode'] = paymentMode;

    return await dioClient.dio.get(
      ApiEndpoints.walletTransactions,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  @override
  Future<Response> withdraw({required Map<String, dynamic> body}) async =>
      await dioClient.dio.post(ApiEndpoints.withdraw, data: body);

  @override
  Future<Response> addCard({required Map<String, dynamic> body}) async =>
      await dioClient.dio.post(ApiEndpoints.addCard, data: body);

  @override
  Future<Response> myCards() async => await dioClient.dio.get(ApiEndpoints.myCard);

  @override
  Future<Response> deleteCard(String? id) async => await dioClient.dio.delete('${ApiEndpoints.deleteCard}/$id');
}
