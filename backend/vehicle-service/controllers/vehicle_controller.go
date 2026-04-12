package controllers

import (
	"net/http"
	"strconv"

	"rentride/vehicle-service/models"
	"rentride/vehicle-service/services"

	"github.com/gin-gonic/gin"
)

type VehicleController struct {
	service *services.VehicleService
}

func NewVehicleController() *VehicleController {
	return &VehicleController{service: services.NewVehicleService()}
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

func (ctrl *VehicleController) Register(c *gin.Context) {
	driverID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	role, _ := ExtractRole(c)
	if role != "driver" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only drivers can register vehicles"})
		return
	}

	var req models.RegisterVehicleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	vehicle, err := ctrl.service.RegisterVehicle(driverID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "data": vehicle})
}

func (ctrl *VehicleController) Update(c *gin.Context) {
	driverID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	vehicleID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid vehicle ID"})
		return
	}

	var req models.UpdateVehicleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	vehicle, err := ctrl.service.UpdateVehicle(driverID, uint(vehicleID), req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": vehicle})
}

func (ctrl *VehicleController) GetDriverVehicles(c *gin.Context) {
	driverID, err := strconv.ParseUint(c.Param("driver_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid driver ID"})
		return
	}

	vehicles, err := ctrl.service.GetDriverVehicles(uint(driverID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch vehicles"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": vehicles})
}

func (ctrl *VehicleController) GetActiveVehicle(c *gin.Context) {
	driverID, err := strconv.ParseUint(c.Param("driver_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid driver ID"})
		return
	}

	vehicle, err := ctrl.service.GetActiveVehicle(uint(driverID))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Active vehicle not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": vehicle})
}

func (ctrl *VehicleController) AdminGetVehicles(c *gin.Context) {
	vehicles, err := ctrl.service.GetAllVehicles()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch vehicles"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": vehicles})
}
