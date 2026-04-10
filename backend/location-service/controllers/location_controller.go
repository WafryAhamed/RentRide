package controllers

import (
	"net/http"

	"rentride/location-service/models"
	"rentride/location-service/services"

	"github.com/gin-gonic/gin"
)

type LocationController struct {
	service *services.LocationService
}

func NewLocationController() *LocationController {
	return &LocationController{service: services.NewLocationService()}
}

func ExtractUserID(c *gin.Context) (uint, bool) {
	val, exists := c.Get("user_id")
	if !exists {
		return 0, false
	}
	if fval, ok := val.(float64); ok {
		return uint(fval), true
	}
	return val.(uint), true
}

func ExtractRole(c *gin.Context) (string, bool) {
	val, exists := c.Get("role")
	if !exists {
		return "", false
	}
	return val.(string), true
}

// UpdateDriverLocation accepts a driver's GPS ping and saves it using an Upsert
func (ctrl *LocationController) UpdateDriverLocation(c *gin.Context) {
	driverID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	role, _ := ExtractRole(c)
	if role != "driver" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only drivers can update live locations"})
		return
	}

	var req models.UpdateLocationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := ctrl.service.UpdateLocation(driverID, req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update location"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Location updated successfully"})
}

// SearchNearby queries the DB for active drivers near a given coordinate
func (ctrl *LocationController) SearchNearby(c *gin.Context) {
	var req models.SearchNearbyRequest
	if err := c.ShouldBindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	drivers, err := ctrl.service.GetNearbyDrivers(req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": drivers})
}
