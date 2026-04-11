package models

import (
	"time"

	"gorm.io/gorm"
)

// NotificationType enum
type NotificationType string

const (
	TypeRideRequest   NotificationType = "RIDE_REQUEST"
	TypeRideAccepted  NotificationType = "RIDE_ACCEPTED"
	TypeRideArriving  NotificationType = "RIDE_ARRIVING"
	TypeRideStarted   NotificationType = "RIDE_STARTED"
	TypeRideCompleted NotificationType = "RIDE_COMPLETED"
	TypeRideCancelled NotificationType = "RIDE_CANCELLED"
	TypePayment       NotificationType = "PAYMENT"
	TypeSystem        NotificationType = "SYSTEM"
)

// Notification represents an in-app notification for a user
type Notification struct {
	ID        uint             `gorm:"primaryKey" json:"id"`
	UserID    uint             `gorm:"not null;index" json:"user_id"`
	Title     string           `gorm:"type:varchar(255);not null" json:"title"`
	Body      string           `gorm:"type:text;not null" json:"body"`
	Type      NotificationType `gorm:"type:varchar(30);not null" json:"type"`
	IsRead    bool             `gorm:"default:false;index" json:"is_read"`
	Metadata  string           `gorm:"type:jsonb;default:'{}'" json:"metadata"` // Extra context as JSON
	CreatedAt time.Time        `json:"created_at"`
	UpdatedAt time.Time        `json:"updated_at"`
	DeletedAt gorm.DeletedAt   `gorm:"index" json:"-"`
}

func (Notification) TableName() string {
	return "notifications"
}

// SendNotificationRequest is the internal payload to create a notification
type SendNotificationRequest struct {
	UserID   uint             `json:"user_id" binding:"required"`
	Title    string           `json:"title" binding:"required"`
	Body     string           `json:"body" binding:"required"`
	Type     NotificationType `json:"type" binding:"required"`
	Metadata string           `json:"metadata,omitempty"`
}
