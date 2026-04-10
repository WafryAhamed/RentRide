package models

import (
	"time"
	"gorm.io/gorm"
)

// VehicleCategory Enum
type VehicleCategory string

const (
	CategoryHatchback VehicleCategory = "HATCHBACK"
	CategorySedan     VehicleCategory = "SEDAN"
	CategorySUV       VehicleCategory = "SUV"
	CategoryVan       VehicleCategory = "VAN"
)

// Vehicle Model represents a driver's car
type Vehicle struct {
	ID           uint            `gorm:"primaryKey" json:"id"`
	DriverID     uint            `gorm:"not null;index" json:"driver_id"`
	Make         string          `gorm:"type:varchar(50);not null" json:"make"`
	Model        string          `gorm:"type:varchar(50);not null" json:"model"`
	Year         int             `gorm:"not null" json:"year"`
	LicensePlate string          `gorm:"type:varchar(20);uniqueIndex;not null" json:"license_plate"`
	Category     VehicleCategory `gorm:"type:varchar(20);not null" json:"category"`
	Color        string          `gorm:"type:varchar(30)" json:"color"`
	IsActive     bool            `gorm:"default:false;index" json:"is_active"`
	
	CreatedAt    time.Time       `json:"created_at"`
	UpdatedAt    time.Time       `json:"updated_at"`
	DeletedAt    gorm.DeletedAt  `gorm:"index" json:"-"`
}

func (Vehicle) TableName() string {
	return "vehicles"
}

// RegisterVehicleRequest DTO
type RegisterVehicleRequest struct {
	Make         string          `json:"make" binding:"required"`
	Model        string          `json:"model" binding:"required"`
	Year         int             `json:"year" binding:"required"`
	LicensePlate string          `json:"license_plate" binding:"required"`
	Category     VehicleCategory `json:"category" binding:"required"`
	Color        string          `json:"color"`
	IsActive     bool            `json:"is_active"`
}

// UpdateVehicleRequest DTO
type UpdateVehicleRequest struct {
	Make         *string          `json:"make,omitempty"`
	Model        *string          `json:"model,omitempty"`
	Year         *int             `json:"year,omitempty"`
	LicensePlate *string          `json:"license_plate,omitempty"`
	Category     *VehicleCategory `json:"category,omitempty"`
	Color        *string          `json:"color,omitempty"`
	IsActive     *bool            `json:"is_active,omitempty"`
}
