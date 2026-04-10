import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel>? _notifications;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await MockNotificationService.getNotifications();
    if (mounted) setState(() => _notifications = data);
  }

  IconData _typeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.ride: return Icons.directions_car;
      case NotificationType.promo: return Icons.local_offer;
      case NotificationType.system: return Icons.settings;
      case NotificationType.guide: return Icons.explore;
    }
  }

  Color _typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.ride: return AppColors.primary;
      case NotificationType.promo: return AppColors.accent;
      case NotificationType.system: return AppColors.textMuted;
      case NotificationType.guide: return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async { await MockNotificationService.markAllAsRead(); _load(); },
            child: Text('Mark all read', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: _notifications == null
          ? Center(child: LoadingShimmer.card())
          : _notifications!.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🔔', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text('No notifications', style: AppTextStyles.heading3),
                  ]),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications!.length,
                  separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
                  itemBuilder: (context, i) {
                    final n = _notifications![i];
                    return Container(
                      color: n.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.04),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        leading: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: _typeColor(n.type).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_typeIcon(n.type), color: _typeColor(n.type), size: 22),
                        ),
                        title: Text(n.title, style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: n.isRead ? FontWeight.w400 : FontWeight.w600,
                        )),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.message, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(Formatters.relativeTime(n.createdAt), style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        trailing: !n.isRead
                            ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))
                            : null,
                        onTap: () async {
                          await MockNotificationService.markAsRead(n.id);
                          _load();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
