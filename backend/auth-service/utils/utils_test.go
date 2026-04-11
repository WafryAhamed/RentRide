package utils

import (
	"os"
	"testing"
)

func TestHashPassword(t *testing.T) {
	password := "testpassword123"
	hashed, err := HashPassword(password)
	if err != nil {
		t.Fatalf("HashPassword failed: %v", err)
	}

	if hashed == password {
		t.Error("Hashed password should not equal plain password")
	}

	if len(hashed) == 0 {
		t.Error("Hashed password should not be empty")
	}
}

func TestCheckPasswordHash_Valid(t *testing.T) {
	password := "testpassword123"
	hashed, err := HashPassword(password)
	if err != nil {
		t.Fatalf("HashPassword failed: %v", err)
	}

	if !CheckPasswordHash(password, hashed) {
		t.Error("CheckPasswordHash should return true for valid password")
	}
}

func TestCheckPasswordHash_Invalid(t *testing.T) {
	password := "testpassword123"
	hashed, err := HashPassword(password)
	if err != nil {
		t.Fatalf("HashPassword failed: %v", err)
	}

	if CheckPasswordHash("wrongpassword", hashed) {
		t.Error("CheckPasswordHash should return false for wrong password")
	}
}

func TestGenerateAccessToken(t *testing.T) {
	os.Setenv("JWT_ACCESS_SECRET", "test-secret-key")
	defer os.Unsetenv("JWT_ACCESS_SECRET")

	token, expiresIn, err := GenerateAccessToken(1, "test@example.com", "rider")
	if err != nil {
		t.Fatalf("GenerateAccessToken failed: %v", err)
	}

	if token == "" {
		t.Error("Token should not be empty")
	}

	if expiresIn != 900 {
		t.Errorf("Expected 900 seconds expiry, got %d", expiresIn)
	}
}

func TestGenerateAccessToken_NoSecret(t *testing.T) {
	os.Unsetenv("JWT_ACCESS_SECRET")

	_, _, err := GenerateAccessToken(1, "test@example.com", "rider")
	if err == nil {
		t.Error("Should fail when JWT_ACCESS_SECRET is not set")
	}
}

func TestGenerateRefreshToken(t *testing.T) {
	os.Setenv("JWT_REFRESH_SECRET", "test-refresh-secret")
	defer os.Unsetenv("JWT_REFRESH_SECRET")

	token, expiry, err := GenerateRefreshToken(1)
	if err != nil {
		t.Fatalf("GenerateRefreshToken failed: %v", err)
	}

	if token == "" {
		t.Error("Refresh token should not be empty")
	}

	if expiry.IsZero() {
		t.Error("Expiry should not be zero")
	}
}

func TestVerifyRefreshToken_Valid(t *testing.T) {
	os.Setenv("JWT_REFRESH_SECRET", "test-refresh-secret")
	defer os.Unsetenv("JWT_REFRESH_SECRET")

	token, _, err := GenerateRefreshToken(42)
	if err != nil {
		t.Fatalf("GenerateRefreshToken failed: %v", err)
	}

	claims, err := VerifyRefreshToken(token)
	if err != nil {
		t.Fatalf("VerifyRefreshToken failed: %v", err)
	}

	if claims.UserID != 42 {
		t.Errorf("Expected UserID 42, got %d", claims.UserID)
	}
}

func TestVerifyRefreshToken_Invalid(t *testing.T) {
	os.Setenv("JWT_REFRESH_SECRET", "test-refresh-secret")
	defer os.Unsetenv("JWT_REFRESH_SECRET")

	_, err := VerifyRefreshToken("invalid-token")
	if err == nil {
		t.Error("Should fail with invalid token")
	}
}
