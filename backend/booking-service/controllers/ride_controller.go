package controllers

import (
	"net/http"
	"strconv"

	"rentride/booking-service/models"
	"rentride/booking-service/services"

	"github.com/gin-gonic/gin"
)

type RideController struct {
	service *services.RideService
}

func NewRideController() *RideController {
	return &RideController{service: services.NewRideService()}
}

// ExtractUserID is a helper that gets the parsed int from JWT context
func ExtractUserID(c *gin.Context) (uint, bool) {
	val, exists := c.Get("user_id")
	if !exists {
		return 0, false
	}
	// Depending on jwt mapping, it might be a float64
	if fval, ok := val.(float64); ok {
		return uint(fval), true
	}
	return val.(uint), true
}

func (ctrl *RideController) RequestRide(c *gin.Context) {
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var req models.CreateRideRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	ride, err := ctrl.service.RequestRide(userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "data": ride})
}

func (ctrl *RideController) UpdateStatus(c *gin.Context) {
	// Represents driver ID from JWT if a driver is making the call
	actorID, _ := ExtractUserID(c) 
	
	rideID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ride ID"})
		return
	}

	var req models.UpdateRideStatusRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	ride, err := ctrl.service.UpdateRideStatus(uint(rideID), &actorID, req.Status)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": ride})
}

func (ctrl *RideController) GetRide(c *gin.Context) {
	rideID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ride ID"})
		return
	}

	ride, err := ctrl.service.GetRideByID(uint(rideID))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Ride not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": ride})
}

func (ctrl *RideController) GetUserRides(c *gin.Context) {
	userID, err := strconv.ParseUint(c.Param("user_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	rides, err := ctrl.service.GetUserHistory(uint(userID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch rides"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": rides})
}

func (ctrl *RideController) AdminGetRides(c *gin.Context) {
	rides, err := ctrl.service.GetAllRides()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch all rides"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": rides})
}
