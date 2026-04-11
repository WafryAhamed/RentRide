package services

import (
	"testing"

	"rentride/auth-service/models"
	"rentride/auth-service/testutils"

	"github.com/stretchr/testify/assert"
)

func TestAuthService_Register(t *testing.T) {
	// 1. Setup Phase
	testutils.SetupTestEnv()
	testutils.SetupTestDB()
	defer testutils.TeardownTestDB()

	authService := NewAuthService()

	// 2. Execution Phase
	req := models.RegisterRequest{
		FullName: "Test User",
		Email:    "test@rentride.com",
		Phone:    "0771234567",
		Password: "password123",
		Role:     "rider",
	}

	res, err := authService.Register(req)

	// 3. Assertion Phase
	assert.NoError(t, err)
	assert.NotNil(t, res)
	assert.NotEmpty(t, res.AccessToken)
	assert.Equal(t, "Bearer", res.TokenType)

	// Try registering duplicate email
	res2, err2 := authService.Register(req)
	assert.Error(t, err2)
	assert.Equal(t, "user with this email already exists", err2.Error())
	assert.Nil(t, res2)
}

func TestAuthService_Login(t *testing.T) {
	// 1. Setup Phase
	testutils.SetupTestEnv()
	testutils.SetupTestDB()
	defer testutils.TeardownTestDB()

	authService := NewAuthService()

	// Register a test user
	reqReg := models.RegisterRequest{
		FullName: "Login User",
		Email:    "login@rentride.com",
		Phone:    "0777654321",
		Password: "securepassword",
		Role:     "driver",
	}
	_, _ = authService.Register(reqReg)

	// 2. Execution Phase (Correct Login)
	reqLogin := models.LoginRequest{
		Email:    "login@rentride.com",
		Password: "securepassword",
	}

	res, err := authService.Login(reqLogin)

	// 3. Assertion Phase
	assert.NoError(t, err)
	assert.NotNil(t, res)
	assert.NotEmpty(t, res.AccessToken)

	// Invalid password
	reqLoginBad := models.LoginRequest{
		Email:    "login@rentride.com",
		Password: "wrongpassword",
	}
	resBad, errBad := authService.Login(reqLoginBad)
	assert.Error(t, errBad)
	assert.Equal(t, "invalid email or password", errBad.Error())
	assert.Nil(t, resBad)
}
