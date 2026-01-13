import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../../data/models/notification/notification_model.dart';
import '../../data/services/notification_service_api.dart';
import 'base_repository.dart';
import 'interfaces/notification_repo_interface.dart';

class NotificationRepoImpl extends BaseRepository implements INotificationRepository {
  final NotificationServiceApi notificationService;

  NotificationRepoImpl({required this.notificationService});

  @override
  Future<Either<Failure, NotificationListResponse>> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
  }) async {
    return await safeApiCall(() async {
      final response = await notificationService.getNotifications(
        page: page,
        size: size,
        unreadOnly: unreadOnly,
      );
      return NotificationListResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, UnreadCountResponse>> getUnreadCount() async {
    return await safeApiCall(() async {
      final response = await notificationService.getUnreadCount();
      return UnreadCountResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, void>> markAsRead(int notificationId) async {
    return await safeApiCall(() async {
      await notificationService.markAsRead(notificationId);
    });
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    return await safeApiCall(() async {
      await notificationService.markAllAsRead();
    });
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications() async {
    return await safeApiCall(() async {
      await notificationService.clearAllNotifications();
    });
  }
}
