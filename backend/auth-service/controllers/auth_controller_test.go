package controllers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"rentride/auth-service/models"
	"rentride/auth-service/testutils"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func fetchTestRouter() *gin.Engine {
	testutils.SetupTestEnv()
	testutils.SetupTestDB()
	router := testutils.SetupRouter()
	
	authCtrl := NewAuthController()
	router.POST("/register", authCtrl.Register)
	router.POST("/login", authCtrl.Login)
	return router
}

func TestAuthController_Register(t *testing.T) {
	router := fetchTestRouter()
	defer testutils.TeardownTestDB()

	// 1. Setup Request Payload
	payload := models.RegisterRequest{
		FullName: "API User",
		Email:    "api@rentride.com",
		Phone:    "0712345678",
		Password: "password",
		Role:     "ADMIN",
	}

	jsonValue, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", "/register", bytes.NewBuffer(jsonValue))
	req.Header.Set("Content-Type", "application/json")

	// 2. Record Response
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	// 3. Assertions
	assert.Equal(t, http.StatusCreated, w.Code)
	
	// Parse JSON
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)

	assert.True(t, response["success"].(bool))
	assert.Equal(t, "User registered successfully", response["message"].(string))
	assert.NotNil(t, response["data"]) // Should contain tokens
}

// We import gin up top implicitly via router return if needed, but wait: wait I must import gin!
