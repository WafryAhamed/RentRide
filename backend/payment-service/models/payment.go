package models

import (
	"time"

	"gorm.io/gorm"
)

// PaymentStatus defines the lifecycle of a cash payment
type PaymentStatus string

const (
	PaymentPending   PaymentStatus = "PENDING"
	PaymentCollected PaymentStatus = "COLLECTED"
	PaymentConfirmed PaymentStatus = "CONFIRMED"
	PaymentCancelled PaymentStatus = "CANCELLED"
)

// PaymentMethod defines the payment method (cash only for now)
type PaymentMethod string

const (
	MethodCash PaymentMethod = "CASH"
	MethodQR   PaymentMethod = "QR"
)

// Payment represents a payment record for a ride
type Payment struct {
	ID            uint           `gorm:"primaryKey" json:"id"`
	RideID        uint           `gorm:"not null;uniqueIndex" json:"ride_id"`
	UserID        uint           `gorm:"not null;index" json:"user_id"`
	DriverID      uint           `gorm:"not null;index" json:"driver_id"`
	Amount        float64        `gorm:"type:decimal(10,2);not null" json:"amount"`
	PaymentMethod PaymentMethod  `gorm:"type:varchar(20);default:'CASH'" json:"payment_method"`
	Status        PaymentStatus  `gorm:"type:varchar(20);default:'PENDING'" json:"status"`
	CollectedAt   *time.Time     `json:"collected_at,omitempty"`
	ConfirmedAt   *time.Time     `json:"confirmed_at,omitempty"`
	Notes         string         `gorm:"type:text" json:"notes,omitempty"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
	DeletedAt     gorm.DeletedAt `gorm:"index" json:"-"`
}

func (Payment) TableName() string {
	return "payments"
}

// CreatePaymentRequest is the payload to create a payment record
type CreatePaymentRequest struct {
	RideID   uint    `json:"ride_id" binding:"required"`
	UserID   uint    `json:"user_id" binding:"required"`
	DriverID uint    `json:"driver_id" binding:"required"`
	Amount   float64 `json:"amount" binding:"required"`
}

// CollectPaymentRequest is used by driver to mark cash as collected
type CollectPaymentRequest struct {
	Notes string `json:"notes,omitempty"`
}
