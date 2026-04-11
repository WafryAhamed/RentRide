package models

import (
	"time"
)

type Place struct {
	ID           uint      `gorm:"primaryKey" json:"id"`
	Name         string    `gorm:"not null" json:"name"`
	Description  string    `gorm:"type:text;not null" json:"description"`
	Category     string    `gorm:"not null" json:"category"`
	City         string    `gorm:"not null" json:"city"`
	Latitude     float64   `gorm:"not null" json:"latitude"`
	Longitude    float64   `gorm:"not null" json:"longitude"`
	Images       string    `gorm:"type:text" json:"images"` // Stored as comma-separated URLs or JSON array
	Rating       float64   `gorm:"default:0" json:"rating"`
	ReviewCount  int       `gorm:"default:0" json:"review_count"`
	OpeningHours string    `json:"opening_hours"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}
