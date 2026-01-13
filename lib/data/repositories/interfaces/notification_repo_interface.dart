import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/notification/notification_model.dart';

abstract class INotificationRepository {
  Future<Either<Failure, NotificationListResponse>> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
  });

  Future<Either<Failure, UnreadCountResponse>> getUnreadCount();

  Future<Either<Failure, void>> markAsRead(int notificationId);

  Future<Either<Failure, void>> markAllAsRead();

  Future<Either<Failure, void>> clearAllNotifications();
}
