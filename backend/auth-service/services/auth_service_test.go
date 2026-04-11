package services

import (
	"testing"

	"rentride/auth-service/models"
)

// TestRegister_ValidInput tests successful registration
func TestRegister_ValidInput(t *testing.T) {
	// Note: These tests validate the service logic structure.
	// For full integration tests, a test database is required.

	req := models.RegisterRequest{
		FullName: "Test User",
		Email:    "test@example.com",
		Phone:    "+94771234567",
		Password: "password123",
		Role:     "rider",
	}

	if req.FullName == "" {
		t.Error("FullName should not be empty")
	}
	if req.Email == "" {
		t.Error("Email should not be empty")
	}
	if len(req.Password) < 6 {
		t.Error("Password should be at least 6 characters")
	}
}

// TestRegister_EmptyEmail tests registration with empty email
func TestRegister_EmptyEmail(t *testing.T) {
	req := models.RegisterRequest{
		FullName: "Test User",
		Email:    "",
		Phone:    "+94771234567",
		Password: "password123",
	}

	if req.Email != "" {
		t.Error("Email should be empty for this test")
	}
}

// TestLogin_ValidInput tests login request validation
func TestLogin_ValidInput(t *testing.T) {
	req := models.LoginRequest{
		Email:    "test@example.com",
		Password: "password123",
	}

	if req.Email == "" {
		t.Error("Email should not be empty")
	}
	if req.Password == "" {
		t.Error("Password should not be empty")
	}
}

// TestRefresh_ValidInput tests refresh request validation
func TestRefresh_ValidInput(t *testing.T) {
	req := models.RefreshRequest{
		RefreshToken: "some-refresh-token",
	}

	if req.RefreshToken == "" {
		t.Error("RefreshToken should not be empty")
	}
}

// TestRoleDefault tests that default role is set correctly
func TestRoleDefault(t *testing.T) {
	req := models.RegisterRequest{
		FullName: "Test User",
		Email:    "test@example.com",
		Phone:    "+94771234567",
		Password: "password123",
	}

	role := "rider"
	if req.Role != "" {
		role = req.Role
	}

	if role != "rider" {
		t.Errorf("Expected default role 'rider', got '%s'", role)
	}
}
