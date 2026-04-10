package models

import (
	"time"

	"gorm.io/gorm"
)

// User represents a RentRide platform user (rider or driver).
type User struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	FullName  string         `gorm:"type:varchar(100);not null" json:"full_name" binding:"required"`
	Email     string         `gorm:"type:varchar(100);uniqueIndex;not null" json:"email" binding:"required,email"`
	Phone     string         `gorm:"type:varchar(20);uniqueIndex;not null" json:"phone" binding:"required"`
	Password  string         `gorm:"type:varchar(255);not null" json:"-" binding:"required,min=6"`
	Role      string         `gorm:"type:varchar(20);default:'rider'" json:"role"`
	AvatarURL string         `gorm:"type:varchar(500)" json:"avatar_url"`
	IsActive  bool           `gorm:"default:true" json:"is_active"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

// TableName overrides the default table name.
func (User) TableName() string {
	return "users"
}

// UserResponse is the safe representation of a user (no password).
type UserResponse struct {
	ID        uint      `json:"id"`
	FullName  string    `json:"full_name"`
	Email     string    `json:"email"`
	Phone     string    `json:"phone"`
	Role      string    `json:"role"`
	AvatarURL string    `json:"avatar_url"`
	IsActive  bool      `json:"is_active"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// ToResponse converts a User to a safe UserResponse (strips password).
func (u *User) ToResponse() UserResponse {
	return UserResponse{
		ID:        u.ID,
		FullName:  u.FullName,
		Email:     u.Email,
		Phone:     u.Phone,
		Role:      u.Role,
		AvatarURL: u.AvatarURL,
		IsActive:  u.IsActive,
		CreatedAt: u.CreatedAt,
		UpdatedAt: u.UpdatedAt,
	}
}

// CreateUserRequest is the input for creating a new user.
type CreateUserRequest struct {
	FullName string `json:"full_name" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Phone    string `json:"phone" binding:"required"`
	Password string `json:"password" binding:"required,min=6"`
	Role     string `json:"role"`
}

// UpdateUserRequest is the input for updating an existing user.
type UpdateUserRequest struct {
	FullName  string `json:"full_name"`
	Phone     string `json:"phone"`
	AvatarURL string `json:"avatar_url"`
}
