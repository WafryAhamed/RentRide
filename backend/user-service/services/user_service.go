package services

import (
	"errors"

	"rentride/user-service/models"
	"rentride/user-service/repository"
)

// UserService contains business logic for user operations.
type UserService struct {
	repo *repository.UserRepository
}

// NewUserService creates a new UserService instance.
func NewUserService() *UserService {
	return &UserService{
		repo: repository.NewUserRepository(),
	}
}

// CreateUser creates a new user after validation.
func (s *UserService) CreateUser(req models.CreateUserRequest) (*models.UserResponse, error) {
	// Check if email already exists
	existing, _ := s.repo.FindByEmail(req.Email)
	if existing != nil {
		return nil, errors.New("a user with this email already exists")
	}

	user := models.User{
		FullName: req.FullName,
		Email:    req.Email,
		Phone:    req.Phone,
		Password: req.Password, // TODO: Hash password with bcrypt in production
		Role:     req.Role,
		IsActive: true,
	}

	if user.Role == "" {
		user.Role = "rider"
	}

	if err := s.repo.Create(&user); err != nil {
		return nil, err
	}

	response := user.ToResponse()
	return &response, nil
}

// GetAllUsers retrieves all users with pagination.
func (s *UserService) GetAllUsers(page, limit int) ([]models.UserResponse, int64, error) {
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 10
	}

	users, total, err := s.repo.FindAll(page, limit)
	if err != nil {
		return nil, 0, err
	}

	var responses []models.UserResponse
	for _, user := range users {
		responses = append(responses, user.ToResponse())
	}

	return responses, total, nil
}

// GetUserByID retrieves a single user by ID.
func (s *UserService) GetUserByID(id uint) (*models.UserResponse, error) {
	user, err := s.repo.FindByID(id)
	if err != nil {
		return nil, errors.New("user not found")
	}

	response := user.ToResponse()
	return &response, nil
}

// UpdateUser updates an existing user.
func (s *UserService) UpdateUser(id uint, req models.UpdateUserRequest) (*models.UserResponse, error) {
	user, err := s.repo.FindByID(id)
	if err != nil {
		return nil, errors.New("user not found")
	}

	if req.FullName != "" {
		user.FullName = req.FullName
	}
	if req.Phone != "" {
		user.Phone = req.Phone
	}
	if req.AvatarURL != "" {
		user.AvatarURL = req.AvatarURL
	}

	if err := s.repo.Update(user); err != nil {
		return nil, err
	}

	response := user.ToResponse()
	return &response, nil
}

// DeleteUser soft-deletes a user.
func (s *UserService) DeleteUser(id uint) error {
	_, err := s.repo.FindByID(id)
	if err != nil {
		return errors.New("user not found")
	}

	return s.repo.Delete(id)
}
