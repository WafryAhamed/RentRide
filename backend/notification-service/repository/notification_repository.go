package repository

import (
	"rentride/notification-service/config"
	"rentride/notification-service/models"

	"gorm.io/gorm"
)

type NotificationRepository struct {
	db *gorm.DB
}

func NewNotificationRepository() *NotificationRepository {
	return &NotificationRepository{db: config.DB}
}

// Create inserts a new notification
func (r *NotificationRepository) Create(notification *models.Notification) error {
	return r.db.Create(notification).Error
}

// FindByUserID fetches all notifications for a user, newest first
func (r *NotificationRepository) FindByUserID(userID uint, limit int) ([]models.Notification, error) {
	var notifications []models.Notification
	query := r.db.Where("user_id = ?", userID).Order("created_at desc")
	if limit > 0 {
		query = query.Limit(limit)
	}
	err := query.Find(&notifications).Error
	return notifications, err
}

// CountUnread counts unread notifications for a user
func (r *NotificationRepository) CountUnread(userID uint) (int64, error) {
	var count int64
	err := r.db.Model(&models.Notification{}).
		Where("user_id = ? AND is_read = false", userID).
		Count(&count).Error
	return count, err
}

// MarkAsRead marks a notification as read
func (r *NotificationRepository) MarkAsRead(id uint, userID uint) error {
	return r.db.Model(&models.Notification{}).
		Where("id = ? AND user_id = ?", id, userID).
		Update("is_read", true).Error
}

// MarkAllAsRead marks all unread notifications as read for a user
func (r *NotificationRepository) MarkAllAsRead(userID uint) error {
	return r.db.Model(&models.Notification{}).
		Where("user_id = ? AND is_read = false", userID).
		Update("is_read", true).Error
}
