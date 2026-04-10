package controllers

import (
	"net/http"
	"time"

	"rentride/user-service/config"

	"github.com/gin-gonic/gin"
)

var startTime = time.Now()

// HealthCheck godoc
// @Summary      Health check
// @Description  Returns the health status of the User Service
// @Tags         health
// @Produce      json
// @Success      200  {object}  map[string]interface{}
// @Router       /api/v1/health [get]
func HealthCheck(c *gin.Context) {
	// Check DB connectivity
	dbStatus := "connected"
	sqlDB, err := config.DB.DB()
	if err != nil || sqlDB.Ping() != nil {
		dbStatus = "disconnected"
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"service": "RentRide User Service",
		"version": "1.0.0",
		"status":  "healthy",
		"uptime":  time.Since(startTime).String(),
		"database": gin.H{
			"status": dbStatus,
			"type":   "PostgreSQL",
		},
		"timestamp": time.Now().UTC().Format(time.RFC3339),
	})
}
