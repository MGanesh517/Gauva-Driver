import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../models/chat_message_response/chat_message_response.dart';
import '../../models/common_response.dart';

abstract class IChatRepo {
  Future<Either<Failure, ChatResponse>> getMessage(
      {required int userId});
  Future<Either<Failure, CommonResponse>> sendMessage(
      {required int receiverId, required String message});
}
