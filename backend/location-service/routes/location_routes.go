package routes

import (
	"rentride/location-service/controllers"
	"rentride/location-service/middleware"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine) {
	v1 := router.Group("/api/v1")
	{
		locCtrl := controllers.NewLocationController()
		
		locations := v1.Group("/locations")
		locations.Use(middleware.AuthRequired())
		{
			// Driver updates their location
			locations.PUT("/driver", locCtrl.UpdateDriverLocation)
			
			// Rider hunts for nearby drivers
			locations.GET("/nearby", locCtrl.SearchNearby)
		}
	}
}
