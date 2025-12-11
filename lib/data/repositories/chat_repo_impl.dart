import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../../domain/interfaces/chat_service.dart';
import '../models/chat_message_response/chat_message_response.dart';
import '../models/common_response.dart';
import 'base_repository.dart';
import 'interfaces/chat_repo_interface.dart';

class ChatRepoImpl extends BaseRepository implements IChatRepo {
  final IChatService chatService;

  ChatRepoImpl({required this.chatService});
  @override
  Future<Either<Failure, ChatResponse>> getMessage(
      {required int userId}) async => await safeApiCall(() async {
      final response = await chatService.getMessage(userId);
      return ChatResponse.fromJson(response.data);
    });

  @override
  Future<Either<Failure, CommonResponse>> sendMessage(
      {required int receiverId, required String message}) async => await safeApiCall(() async {
      final response = await chatService.sendMessage(message: message, receiverId: receiverId);
      return CommonResponse.fromJson(response.data);
    });
}
