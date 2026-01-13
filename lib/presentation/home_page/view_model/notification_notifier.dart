import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/notification/notification_model.dart';
import '../../../data/repositories/interfaces/notification_repo_interface.dart';

class NotificationNotifier extends StateNotifier<AppState<NotificationListResponse>> {
  final INotificationRepository repository;

  NotificationNotifier(this.repository) : super(const AppState.initial()) {
    loadNotifications();
  }

  Future<void> loadNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
    bool refresh = false,
  }) async {
    if (!refresh) {
      state = const AppState.loading();
    }

    final result = await repository.getNotifications(
      page: page,
      size: size,
      unreadOnly: unreadOnly,
    );

    result.fold(
      (failure) => state = AppState.error(failure),
      (data) => state = AppState.success(data),
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final result = await repository.markAsRead(notificationId);
    result.fold(
      (failure) {
        // Handle error if needed - could show error message
        state = AppState.error(failure);
      },
      (_) {
        // Refresh notifications after marking as read
        loadNotifications(refresh: true);
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await repository.markAllAsRead();
    result.fold(
      (failure) {
        state = AppState.error(failure);
      },
      (_) {
        loadNotifications(refresh: true);
      },
    );
  }

  Future<void> clearAll() async {
    final result = await repository.clearAllNotifications();
    result.fold(
      (failure) {
        state = AppState.error(failure);
      },
      (_) {
        loadNotifications(refresh: true);
      },
    );
  }
}

class UnreadCountNotifier extends StateNotifier<AppState<int>> {
  final INotificationRepository repository;

  UnreadCountNotifier(this.repository) : super(const AppState.initial()) {
    loadUnreadCount();
  }

  Future<void> loadUnreadCount() async {
    final result = await repository.getUnreadCount();
    result.fold(
      (failure) => state = AppState.error(failure),
      (data) => state = AppState.success(data.count),
    );
  }

  void refresh() {
    loadUnreadCount();
  }
}
