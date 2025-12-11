class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json,
      {bool convertPusher = false}) {
    if (convertPusher) {
      final messageJson = json['message'];
      return Message(
        id: messageJson['id'],
        senderId: messageJson['sender_id'],
        receiverId: messageJson['receiver_id'],
        message: messageJson['message'],
        createdAt: DateTime.parse(messageJson['created_at']),
        updatedAt: DateTime.parse(messageJson['updated_at']),
      );
    } else {
      return Message(
        id: json['id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        message: json['message'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
    }
  }
}
