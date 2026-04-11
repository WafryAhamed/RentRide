package services

import (
	"errors"

	"rentride/notification-service/models"
	"rentride/notification-service/repository"
)

type NotificationService struct {
	repo *repository.NotificationRepository
}

func NewNotificationService() *NotificationService {
	return &NotificationService{repo: repository.NewNotificationRepository()}
}

// SendNotification creates a new notification for a user
func (s *NotificationService) SendNotification(req models.SendNotificationRequest) (*models.Notification, error) {
	notification := &models.Notification{
		UserID:   req.UserID,
		Title:    req.Title,
		Body:     req.Body,
		Type:     req.Type,
		Metadata: req.Metadata,
		IsRead:   false,
	}

	if notification.Metadata == "" {
		notification.Metadata = "{}"
	}

	if err := s.repo.Create(notification); err != nil {
		return nil, errors.New("failed to create notification")
	}

	return notification, nil
}

// GetUserNotifications fetches notifications for a user
func (s *NotificationService) GetUserNotifications(userID uint, limit int) ([]models.Notification, error) {
	if limit <= 0 {
		limit = 50 // Default limit
	}
	return s.repo.FindByUserID(userID, limit)
}

// GetUnreadCount counts unread notifications
func (s *NotificationService) GetUnreadCount(userID uint) (int64, error) {
	return s.repo.CountUnread(userID)
}

// MarkAsRead marks a single notification as read
func (s *NotificationService) MarkAsRead(notificationID uint, userID uint) error {
	return s.repo.MarkAsRead(notificationID, userID)
}

// MarkAllAsRead marks all notifications as read
func (s *NotificationService) MarkAllAsRead(userID uint) error {
	return s.repo.MarkAllAsRead(userID)
}
