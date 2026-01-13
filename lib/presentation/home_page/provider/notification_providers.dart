import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/notification/notification_model.dart';
import '../../../data/repositories/interfaces/notification_repo_interface.dart';
import '../../../data/repositories/notification_repo_impl.dart';
import '../../../data/services/notification_service_api.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/notification_notifier.dart';

// Service Provider
final notificationServiceApiProvider = Provider<NotificationServiceApi>((ref) {
  return NotificationServiceApi(dioClient: ref.read(dioClientProvider));
});

// Repository Provider
final notificationRepoProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepoImpl(notificationService: ref.read(notificationServiceApiProvider));
});

// Notifier Providers
final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, AppState<NotificationListResponse>>(
  (ref) => NotificationNotifier(ref.read(notificationRepoProvider)),
);

final unreadCountNotifierProvider = StateNotifierProvider<UnreadCountNotifier, AppState<int>>(
  (ref) => UnreadCountNotifier(ref.read(notificationRepoProvider)),
);
