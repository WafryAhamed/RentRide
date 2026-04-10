package repository

import (
	"time"

	"rentride/auth-service/config"
	"rentride/auth-service/models"

	"gorm.io/gorm"
)

// AuthRepository handles database interactions for users and tokens
type AuthRepository struct {
	db *gorm.DB
}

// NewAuthRepository creates a new AuthRepository instance
func NewAuthRepository() *AuthRepository {
	return &AuthRepository{db: config.DB}
}

// FindUserByEmail looks up a user by email
func (r *AuthRepository) FindUserByEmail(email string) (*models.User, error) {
	var user models.User
	err := r.db.Where("email = ?", email).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// FindUserByID looks up a user by ID
func (r *AuthRepository) FindUserByID(id uint) (*models.User, error) {
	var user models.User
	err := r.db.First(&user, id).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// CreateUser inserts a user. Will be used by /register.
func (r *AuthRepository) CreateUser(user *models.User) error {
	return r.db.Create(user).Error
}

// StoreRefreshToken saves a new refresh token for a user
func (r *AuthRepository) StoreRefreshToken(userID uint, token string, expiresAt time.Time) error {
	rt := models.RefreshToken{
		UserID:    userID,
		Token:     token,
		ExpiresAt: expiresAt,
	}
	return r.db.Create(&rt).Error
}

// DeleteRefreshToken removes a specific refresh token (used on logout or re-auth)
func (r *AuthRepository) DeleteRefreshToken(token string) error {
	return r.db.Where("token = ?", token).Delete(&models.RefreshToken{}).Error
}

// ValidateRefreshToken checks if the token exists in DB and is not expired
func (r *AuthRepository) ValidateRefreshToken(token string) (*models.RefreshToken, error) {
	var rt models.RefreshToken
	err := r.db.Where("token = ? AND expires_at > ?", token, time.Now()).First(&rt).Error
	if err != nil {
		return nil, err
	}
	return &rt, nil
}
