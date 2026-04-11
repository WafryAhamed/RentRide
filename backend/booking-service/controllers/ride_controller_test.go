package controllers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"rentride/booking-service/models"
	"rentride/booking-service/testutils"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func fetchTestRouter() *gin.Engine {
	testutils.SetupTestDB()
	router := testutils.SetupRouter()
	
	rideCtrl := NewRideController()
	
	// Assuming the internal JWT middleware puts user_id in context
	// We inject a fake middleware here for testing the controller cleanly
	authorized := router.Group("/")
	authorized.Use(func(c *gin.Context) {
		c.Set("user_id", uint(1))
		c.Set("role", "rider")
		c.Next()
	})
	
	authorized.POST("/rides", rideCtrl.CreateRide)
	
	adminAuth := router.Group("/admin")
	adminAuth.Use(func(c *gin.Context) {
		c.Set("user_id", uint(99))
		c.Set("role", "ADMIN")
		c.Next()
	})
	adminAuth.GET("/rides", rideCtrl.AdminGetRides)

	return router
}

func TestRideController_CreateRide(t *testing.T) {
	router := fetchTestRouter()
	defer testutils.TeardownTestDB()

	// Setup payload
	payload := models.CreateRideRequest{
		UserID:          1,
		PickupLocation:  "Galle Face",
		DropoffLocation: "Mount Lavinia",
		DistanceKm:      12.0,
		VehicleCategory: "car",
	}

	jsonValue, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", "/rides", bytes.NewBuffer(jsonValue))
	req.Header.Set("Content-Type", "application/json")

	// Execute Test
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	// Assertions
	assert.Equal(t, http.StatusCreated, w.Code)
	
	// Parse JSON
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)

	assert.True(t, response["success"].(bool))
	dataMap := response["data"].(map[string]interface{})
	assert.Equal(t, "Galle Face", dataMap["pickup_location"])
}
