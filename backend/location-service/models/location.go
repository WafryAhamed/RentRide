package models

import (
	"time"
)

// DriverLocation tracks a driver's most recent physical coordinates
type DriverLocation struct {
	DriverID  uint      `gorm:"primaryKey" json:"driver_id"` // Using driver_id as the PK for Upserts
	Latitude  float64   `gorm:"not null" json:"latitude"`
	Longitude float64   `gorm:"not null" json:"longitude"`
	Heading   float64   `json:"heading"` // Direction degrees 0-360
	IsOnline  bool      `gorm:"default:true" json:"is_online"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `gorm:"index" json:"updated_at"` // Indexed to find "recently active" drivers
}

func (DriverLocation) TableName() string {
	return "driver_locations"
}

// UpdateLocationRequest payload sent by Driver Device
type UpdateLocationRequest struct {
	Latitude  float64 `json:"latitude" binding:"required"`
	Longitude float64 `json:"longitude" binding:"required"`
	Heading   float64 `json:"heading"`
}

// SearchNearbyRequest payload sent by User App or Booking Service
type SearchNearbyRequest struct {
	Latitude  float64 `form:"latitude" binding:"required"`
	Longitude float64 `form:"longitude" binding:"required"`
	RadiusKm  float64 `form:"radius_km,default=5.0"`
}
