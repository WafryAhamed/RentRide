import 'package:equatable/equatable.dart';

enum NotificationType { ride, promo, system, guide }

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? actionRoute;
  final String? imageUrl;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.type = NotificationType.system,
    this.isRead = false,
    required this.createdAt,
    this.actionRoute,
    this.imageUrl,
  });

  NotificationModel markRead() => NotificationModel(
    id: id,
    title: title,
    message: message,
    type: type,
    isRead: true,
    createdAt: createdAt,
    actionRoute: actionRoute,
    imageUrl: imageUrl,
  );

  @override
  List<Object?> get props => [id];
}
