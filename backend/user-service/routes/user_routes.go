package routes

import (
	"rentride/core/middleware"
	"rentride/user-service/controllers"

	"github.com/gin-gonic/gin"
)

// RegisterRoutes sets up all API routes for the User Service.
func RegisterRoutes(router *gin.Engine) {
	// API v1 group
	v1 := router.Group("/api/v1")
	{
		// ── Health Check ───────────────────────────────────────
		v1.GET("/health", controllers.HealthCheck)

		// ── User Routes ────────────────────────────────────────
		userCtrl := controllers.NewUserController()
		users := v1.Group("/users")
		{
			users.POST("", userCtrl.CreateUser)       // Create user
			users.GET("/:id", userCtrl.GetUserByID)    // Get user by ID
			users.PUT("/:id", userCtrl.UpdateUser)     // Update user
			users.DELETE("/:id", userCtrl.DeleteUser)  // Delete user
		}

		admin := v1.Group("/admin")
		admin.Use(middleware.AuthRequired())
		admin.Use(middleware.RoleRequired("ADMIN"))
		{
			admin.GET("/users", userCtrl.GetAllUsers) // List all users
		}
	}
}
