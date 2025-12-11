import 'package:dio/dio.dart';

abstract class IChatService {
  Future<Response> getMessage(int userId);
  Future<Response> sendMessage({required String message, required int receiverId});
}
