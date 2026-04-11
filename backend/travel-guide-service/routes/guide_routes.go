package routes

import (
	"rentride/travel-guide-service/controllers"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine, ctrl *controllers.GuideController) {
	v1 := router.Group("/api/v1")
	{
		guides := v1.Group("/guides")
		{
			guides.GET("/places", ctrl.GetPlaces)
			guides.GET("/places/:id", ctrl.GetPlaceByID)
			guides.GET("/categories", ctrl.GetCategories)
			guides.GET("/featured", ctrl.GetFeatured)
		}
	}
}
