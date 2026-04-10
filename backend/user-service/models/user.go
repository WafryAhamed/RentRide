package models

import (
	"time"
	"gorm.io/gorm"
)

type User struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	FullName  string         `gorm:"type:varchar(100);not null" json:"full_name"`
	Email     string         `gorm:"type:varchar(100);uniqueIndex;not null" json:"email"`
	Phone     string         `gorm:"type:varchar(20);uniqueIndex;not null" json:"phone"`
	Password  string         `gorm:"type:varchar(255);not null" json:"-"`
	Role      string         `gorm:"type:varchar(20);default:'rider'" json:"role"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}
