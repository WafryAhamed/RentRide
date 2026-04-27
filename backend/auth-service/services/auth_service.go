package services

import (
	"errors"

	"rentride/auth-service/models"
	"rentride/auth-service/repository"
	"rentride/auth-service/utils"
)

// AuthService encapsulates authentication logic
type AuthService struct {
	repo *repository.AuthRepository
}

func NewAuthService() *AuthService {
	return &AuthService{repo: repository.NewAuthRepository()}
}

// Register registers a new user (hashes password and stores in DB)
func (s *AuthService) Register(req models.RegisterRequest) (*models.AuthResponse, error) {
	existingUser, _ := s.repo.FindUserByEmail(req.Email)
	if existingUser != nil {
		return nil, errors.New("user with this email already exists")
	}

	hashedPassword, err := utils.HashPassword(req.Password)
	if err != nil {
		return nil, errors.New("failed to encrypt password")
	}

	role := "rider"
	if req.Role != "" {
		role = req.Role
	}

	newUser := &models.User{
		FullName: req.FullName,
		Email:    req.Email,
		Phone:    req.Phone,
		Password: hashedPassword,
		Role:     role,
		IsActive: true,
	}

	if err := s.repo.CreateUser(newUser); err != nil {
		return nil, errors.New("failed to create user account")
	}

	// Generating tokens immediately after register
	return s.generateAuthResponse(newUser)
}

// Login authenticates a user and returns tokens
func (s *AuthService) Login(req models.LoginRequest) (*models.AuthResponse, error) {
	user, err := s.repo.FindUserByEmail(req.Email)
	if err != nil {
		return nil, errors.New("invalid email or password")
	}

	if !utils.CheckPasswordHash(req.Password, user.Password) {
		return nil, errors.New("invalid email or password")
	}

	if !user.IsActive {
		return nil, errors.New("account is disabled")
	}

	return s.generateAuthResponse(user)
}

// Refresh generates new tokens if the provided refresh token is still valid
func (s *AuthService) Refresh(req models.RefreshRequest) (*models.AuthResponse, error) {
	// First check DB if token is valid and not expired globally
	_, err := s.repo.ValidateRefreshToken(req.RefreshToken)
	if err != nil {
		return nil, errors.New("invalid or expired refresh token")
	}

	// Then check signature using JWT parsing
	claims, err := utils.VerifyRefreshToken(req.RefreshToken)
	if err != nil {
		// Cleanup the bad token
		s.repo.DeleteRefreshToken(req.RefreshToken)
		return nil, err
	}

	// We need to fetch the user to get their current Role and Email 
	user, err := s.repo.FindUserByID(claims.UserID)
	if err != nil || !user.IsActive {
		return nil, errors.New("user account disabled or unretrievable")
	}

	// Delete old refresh token from DB (rotating it to prevent reuse)
	_ = s.repo.DeleteRefreshToken(req.RefreshToken)

	// Issue new tokens
	return s.generateAuthResponse(user)
}

func (s *AuthService) generateAuthResponse(user *models.User) (*models.AuthResponse, error) {
	accessToken, limitSeconds, err := utils.GenerateAccessToken(user.ID, user.Email, user.Role)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	refreshToken, expiryDate, err := utils.GenerateRefreshToken(user.ID)
	if err != nil {
		return nil, errors.New("failed to generate refresh token")
	}

	err = s.repo.StoreRefreshToken(user.ID, refreshToken, expiryDate)
	if err != nil {
		return nil, errors.New("failed to register device for session")
	}

	return &models.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		TokenType:    "Bearer",
		ExpiresIn:    limitSeconds,
		User:         user.ToSafe(),
	}, nil
}
