class NotificationModel {
  final int? id;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final DateTime? createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      isRead: json['isRead'] as bool? ?? json['read'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'data': data,
    };
  }
}

class NotificationListResponse {
  final List<NotificationModel> notifications;
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final int size;

  NotificationListResponse({
    required this.notifications,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.size,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as List<dynamic>? ?? json['data'] as List<dynamic>? ?? [];
    
    return NotificationListResponse(
      notifications: content
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalElements: json['totalElements'] as int? ?? json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['number'] as int? ?? json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 20,
    );
  }
}

class UnreadCountResponse {
  final int count;

  UnreadCountResponse({required this.count});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      count: json['count'] as int? ?? json['unreadCount'] as int? ?? 0,
    );
  }
}
