package routes

import (
	"github.com/gin-gonic/gin"
	"rentride/user-service/controllers"
)

func SetupRoutes(router *gin.Engine) {
	userGroup := router.Group("/users")
	{
		userGroup.GET("/test", controllers.TestEndpoint)
	}
}
