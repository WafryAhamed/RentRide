package routes

import (
	"rentride/vehicle-service/controllers"
	"rentride/vehicle-service/middleware"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine) {
	v1 := router.Group("/api/v1")
	{
		vehCtrl := controllers.NewVehicleController()
		
		vehicles := v1.Group("/vehicles")
		vehicles.Use(middleware.AuthRequired())
		{
			// Mutating routes
			vehicles.POST("", vehCtrl.Register)
			vehicles.PATCH("/:id", vehCtrl.Update)
			
			// Query routes
			vehicles.GET("/driver/:driver_id", vehCtrl.GetDriverVehicles)
			vehicles.GET("/driver/:driver_id/active", vehCtrl.GetActiveVehicle)
		}

		admin := v1.Group("/admin")
		admin.Use(middleware.AuthRequired())
		admin.Use(middleware.RoleRequired("ADMIN"))
		{
			admin.GET("/vehicles", vehCtrl.AdminGetVehicles)
		}
	}
}
