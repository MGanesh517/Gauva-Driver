class ChatMessageWs {
  final int? id;
  final Map<String, dynamic>? ride;
  final int? senderUserId;
  final int? receiverUserId;
  final String? content;
  final String? createdAt;

  ChatMessageWs({this.id, this.ride, this.senderUserId, this.receiverUserId, this.content, this.createdAt});

  factory ChatMessageWs.fromJson(Map<String, dynamic> json) {
    return ChatMessageWs(
      id: json['id'] as int?,
      ride: json['ride'] as Map<String, dynamic>?,
      senderUserId: json['senderUserId'] as int?,
      receiverUserId: json['receiverUserId'] as int?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride': ride,
      'senderUserId': senderUserId,
      'receiverUserId': receiverUserId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
