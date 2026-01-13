import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../data/models/notification/notification_model.dart';
import '../../home_page/provider/notification_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationNotifierProvider.notifier).loadNotifications(
        page: _currentPage,
        size: _pageSize,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationNotifierProvider);
    final unreadCountState = ref.watch(unreadCountNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCountState.maybeWhen(success: (count) => count > 0, orElse: () => false))
            TextButton(
              onPressed: () async {
                await ref.read(notificationNotifierProvider.notifier).markAllAsRead();
                ref.read(unreadCountNotifierProvider.notifier).refresh();
              },
              child: const Text('Mark All Read'),
            ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear All'),
              ),
            ],
            onSelected: (value) async {
              if (value == 'clear') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Notifications'),
                    content: const Text('Are you sure you want to delete all notifications?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref.read(notificationNotifierProvider.notifier).clearAll();
                  ref.read(unreadCountNotifierProvider.notifier).refresh();
                }
              }
            },
          ),
        ],
      ),
      body: notificationState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (data) {
          if (data.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64.sp, color: Colors.grey),
                  Gap(16.h),
                  Text(
                    'No notifications',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _currentPage = 0;
              await ref.read(notificationNotifierProvider.notifier).loadNotifications(
                page: _currentPage,
                size: _pageSize,
                refresh: true,
              );
              ref.read(unreadCountNotifierProvider.notifier).refresh();
            },
            child: ListView.builder(
              itemCount: data.notifications.length + (_hasMore(data) ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == data.notifications.length) {
                  return _buildLoadMore();
                }

                final notification = data.notifications[index];
                return _NotificationItem(
                  notification: notification,
                  onTap: () async {
                    if (!(notification.isRead ?? false)) {
                      await ref.read(notificationNotifierProvider.notifier).markAsRead(notification.id!);
                      ref.read(unreadCountNotifierProvider.notifier).refresh();
                    }
                  },
                );
              },
            ),
          );
        },
        error: (failure) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
              Gap(16.h),
              Text(
                failure.message,
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              Gap(16.h),
              ElevatedButton(
                onPressed: () {
                  ref.read(notificationNotifierProvider.notifier).loadNotifications();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasMore(NotificationListResponse data) {
    return _currentPage < data.totalPages - 1;
  }

  Widget _buildLoadMore() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return TextButton(
      onPressed: () async {
        setState(() => _isLoadingMore = true);
        _currentPage++;
        await ref.read(notificationNotifierProvider.notifier).loadNotifications(
          page: _currentPage,
          size: _pageSize,
        );
        setState(() => _isLoadingMore = false);
      },
      child: const Text('Load More'),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead ?? false;
    final isDark = isDarkMode();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.transparent
              : (isDark ? Colors.blue.shade900.withValues(alpha: 0.2) : Colors.blue.shade50),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.blue.shade800 : Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications,
                size: 20.sp,
                color: isDark ? Colors.white : Colors.blue.shade900,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? 'Notification',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (notification.message != null) ...[
                    Gap(4.h),
                    Text(
                      notification.message!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (notification.createdAt != null) ...[
                    Gap(8.h),
                    Text(
                      _formatDate(notification.createdAt!),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}
