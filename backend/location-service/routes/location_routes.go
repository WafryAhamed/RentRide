package routes

import (
	"rentride/location-service/controllers"
	"rentride/location-service/middleware"
	ws "rentride/location-service/websocket"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine, hub *ws.Hub) {
	v1 := router.Group("/api/v1")
	{
		locCtrl := controllers.NewLocationController()
		wsCtrl := controllers.NewWSController(hub)

		// REST API routes (require JWT)
		locations := v1.Group("/locations")
		locations.Use(middleware.AuthRequired())
		{
			// Driver updates their location
			locations.PUT("/driver", locCtrl.UpdateDriverLocation)

			// Rider hunts for nearby drivers
			locations.GET("/nearby", locCtrl.SearchNearby)

			// Get online driver count
			locations.GET("/online-count", wsCtrl.GetOnlineDrivers)
		}

		// WebSocket routes (JWT via query param or middleware)
		wsGroup := v1.Group("/ws")
		wsGroup.Use(middleware.AuthRequired())
		{
			wsGroup.GET("/track/:ride_id", wsCtrl.TrackRide)   // Rider tracks ride
			wsGroup.GET("/driver", wsCtrl.DriverConnect)        // Driver pushes location
		}
	}
}
