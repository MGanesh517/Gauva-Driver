import 'package:dio/dio.dart';

abstract class IWalletService {
  Future<Response> getWallets();
  Future<Response> getWalletsTransaction({String? dateTime, String? paymentMode});
  Future<Response> withdraw({required Map<String, dynamic> body});
  // Future<Response> addBalance({required String amount});
  Future<Response> addCard({required Map<String, dynamic> body});
  Future<Response> myCards();
  Future<Response> deleteCard(String? id);

}
