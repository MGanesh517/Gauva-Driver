import 'chat_message.dart';

class ChatResponse {
  final bool? success;
  final String? message;
  final List<Message> data;

  ChatResponse({
     this.success,
     this.message,
    required this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
      success: json['success'],
      message: json['message'],
      data: List<Message>.from(json['data'].map((e) => Message.fromJson(e))),
    );
}
