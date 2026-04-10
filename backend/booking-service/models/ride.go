package models

import (
	"time"

	"gorm.io/gorm"
)

// RideStatus defines the allowed lifecycle states of a ride
type RideStatus string

const (
	StatusPending    RideStatus = "PENDING"
	StatusAccepted   RideStatus = "ACCEPTED"
	StatusArriving   RideStatus = "ARRIVING"
	StatusInProgress RideStatus = "IN_PROGRESS"
	StatusCompleted  RideStatus = "COMPLETED"
	StatusCancelled  RideStatus = "CANCELLED"
)

// Ride represents a single trip booking
type Ride struct {
	ID          uint           `gorm:"primaryKey" json:"id"`
	UserID      uint           `gorm:"not null;index" json:"user_id"`
	DriverID    *uint          `gorm:"index" json:"driver_id,omitempty"`
	VehicleID   *uint          `gorm:"index" json:"vehicle_id,omitempty"`
	
	PickupLat   float64        `gorm:"not null" json:"pickup_lat"`
	PickupLng   float64        `gorm:"not null" json:"pickup_lng"`
	PickupLoc   string         `gorm:"type:varchar(255)" json:"pickup_loc"`
	
	DropoffLat  float64        `gorm:"not null" json:"dropoff_lat"`
	DropoffLng  float64        `gorm:"not null" json:"dropoff_lng"`
	DropoffLoc  string         `gorm:"type:varchar(255)" json:"dropoff_loc"`
	
	Status      RideStatus     `gorm:"type:varchar(20);default:'PENDING'" json:"status"`
	Fare        float64        `gorm:"type:decimal(10,2)" json:"fare"`
	DistanceKm  float64        `gorm:"type:decimal(10,2)" json:"distance_km"`
	DurationMin int            `json:"duration_min"`
	
	StartedAt   *time.Time     `json:"started_at,omitempty"`
	CompletedAt *time.Time     `json:"completed_at,omitempty"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `gorm:"index" json:"-"`
}

func (Ride) TableName() string {
	return "rides"
}

// CreateRideRequest is the payload from the Rider to book a trip
type CreateRideRequest struct {
	PickupLat  float64 `json:"pickup_lat" binding:"required"`
	PickupLng  float64 `json:"pickup_lng" binding:"required"`
	PickupLoc  string  `json:"pickup_loc" binding:"required"`
	DropoffLat float64 `json:"dropoff_lat" binding:"required"`
	DropoffLng float64 `json:"dropoff_lng" binding:"required"`
	DropoffLoc string  `json:"dropoff_loc" binding:"required"`
}

// UpdateRideStatusRequest used by drivers to change status
type UpdateRideStatusRequest struct {
	Status RideStatus `json:"status" binding:"required"`
}
