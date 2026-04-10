import '../models/notification_model.dart';

/// Mock notification service.
class MockNotificationService {
  static final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'n_001', title: 'Ride Completed', message: 'Your ride to World Trade Center has been completed. Fare: Rs. 580',
      type: NotificationType.ride, createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'n_002', title: '🎉 50% Off This Weekend!', message: 'Get 50% off on your first 3 rides this weekend. Use code RIDE50.',
      type: NotificationType.promo, createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'n_003', title: 'Driver Rating', message: 'You rated Kamal Silva 5 stars. Thank you for your feedback!',
      type: NotificationType.ride, isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'n_004', title: 'Explore Sigiriya!', message: 'Discover Sri Lanka\'s most iconic landmark. Book a ride to Sigiriya Rock Fortress.',
      type: NotificationType.guide, createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      id: 'n_005', title: 'App Update Available', message: 'RentRide v2.1 is available with new features and improvements.',
      type: NotificationType.system, isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _notifications;
  }

  static Future<int> getUnreadCount() async {
    return _notifications.where((n) => !n.isRead).length;
  }

  static Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].markRead();
    }
  }

  static Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].markRead();
    }
  }
}
