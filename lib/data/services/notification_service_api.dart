import 'package:dio/dio.dart';
import '../../core/config/api_endpoints.dart';
import 'api/dio_client.dart';

class NotificationServiceApi {
  final DioClient dioClient;

  NotificationServiceApi({required this.dioClient});

  /// Get list of notifications
  /// GET /api/notifications/inbox?page=0&size=20&unreadOnly=false
  Future<Response> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
  }) async {
    return await dioClient.dio.get(
      ApiEndpoints.notificationsInbox,
      queryParameters: {
        'page': page,
        'size': size,
        'unreadOnly': unreadOnly,
      },
    );
  }

  /// Get unread notification count
  /// GET /api/notifications/inbox/unread/count
  Future<Response> getUnreadCount() async {
    return await dioClient.dio.get(ApiEndpoints.notificationsUnreadCount);
  }

  /// Mark one notification as read
  /// POST /api/notifications/inbox/{id}/read
  Future<Response> markAsRead(int notificationId) async {
    return await dioClient.dio.post(
      '${ApiEndpoints.notificationMarkRead}/$notificationId/read',
    );
  }

  /// Mark all notifications as read
  /// POST /api/notifications/inbox/read-all
  Future<Response> markAllAsRead() async {
    return await dioClient.dio.post(ApiEndpoints.notificationsMarkAllRead);
  }

  /// Clear all notifications (delete all)
  /// DELETE /api/notifications/inbox
  Future<Response> clearAllNotifications() async {
    return await dioClient.dio.delete(ApiEndpoints.notificationsClearAll);
  }
}
