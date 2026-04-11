package controllers

import (
	"log"
	"net/http"
	"strconv"

	ws "rentride/location-service/websocket"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true // Allow all origins in development
	},
}

type WSController struct {
	hub *ws.Hub
}

func NewWSController(hub *ws.Hub) *WSController {
	return &WSController{hub: hub}
}

// TrackRide allows a rider to connect via WebSocket and receive real-time location updates
// GET /api/v1/ws/track/:ride_id?token=<jwt>
func (ctrl *WSController) TrackRide(c *gin.Context) {
	rideIDStr := c.Param("ride_id")
	rideID, err := strconv.ParseUint(rideIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ride ID"})
		return
	}

	// Extract user ID from context (set by auth middleware or query param)
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Printf("WebSocket upgrade failed: %v", err)
		return
	}

	client := &ws.Client{
		Hub:      ctrl.hub,
		Conn:     conn,
		Send:     make(chan interface{}, 256),
		UserID:   userID,
		RideID:   uint(rideID),
		IsDriver: false,
	}

	ctrl.hub.Register <- client

	go client.WritePump()
	go client.ReadPump()
}

// DriverConnect allows a driver to connect via WebSocket and push location updates
// GET /api/v1/ws/driver?token=<jwt>
func (ctrl *WSController) DriverConnect(c *gin.Context) {
	driverID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	role, _ := ExtractRole(c)
	if role != "driver" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only drivers can connect"})
		return
	}

	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Printf("WebSocket upgrade failed: %v", err)
		return
	}

	client := &ws.Client{
		Hub:      ctrl.hub,
		Conn:     conn,
		Send:     make(chan interface{}, 256),
		UserID:   driverID,
		IsDriver: true,
	}

	ctrl.hub.Register <- client

	go client.WritePump()
	go client.ReadPump()
}

// GetOnlineDrivers returns the count of currently connected drivers
func (ctrl *WSController) GetOnlineDrivers(c *gin.Context) {
	count := ctrl.hub.GetOnlineDriverCount()
	c.JSON(http.StatusOK, gin.H{"success": true, "data": gin.H{"online_drivers": count}})
}
