import 'package:dio/dio.dart';
import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/chat_service.dart';
import 'api/dio_client.dart';

class ChatService implements IChatService {
  final DioClient dioClient;

  ChatService({required this.dioClient});
  @override
  Future<Response> sendMessage({required String message, required int receiverId})async => dioClient.dio.post(
        ApiEndpoints.sendMessage,
        data: {
          'receiver_id': receiverId,
          'message': message
        }
    );
  @override
  Future<Response> getMessage(int userId) async => dioClient.dio.get(
        ApiEndpoints.getMessage,
        queryParameters: {
          'receiver_id': userId
        }

    );
}
