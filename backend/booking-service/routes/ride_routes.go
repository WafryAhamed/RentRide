package routes

import (
	"rentride/booking-service/controllers"
	"rentride/booking-service/middleware"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine) {
	v1 := router.Group("/api/v1")
	{
		rideCtrl := controllers.NewRideController()
		
		// Secure routes group
		rides := v1.Group("/rides")
		rides.Use(middleware.AuthRequired())
		{
			rides.POST("", rideCtrl.RequestRide)                // Create a ride (User)
			rides.PATCH("/:id/status", rideCtrl.UpdateStatus)   // Update status (Driver/System)
			rides.GET("/:id", rideCtrl.GetRide)                 // Get specific ride
			rides.GET("/user/:user_id", rideCtrl.GetUserRides)  // Get history
		}
	}
}
