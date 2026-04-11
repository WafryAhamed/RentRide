package routes

import (
	"rentride/notification-service/controllers"
	"rentride/notification-service/middleware"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine) {
	v1 := router.Group("/api/v1")
	{
		notifCtrl := controllers.NewNotificationController()

		// User-facing routes (require JWT)
		notifications := v1.Group("/notifications")
		notifications.Use(middleware.AuthRequired())
		{
			notifications.GET("", notifCtrl.GetNotifications)                // Get user notifications
			notifications.GET("/unread-count", notifCtrl.GetUnreadCount)     // Get unread count
			notifications.PATCH("/:id/read", notifCtrl.MarkAsRead)          // Mark as read
			notifications.PATCH("/read-all", notifCtrl.MarkAllAsRead)       // Mark all as read
		}

		// Internal endpoint (called by other services, no JWT required in internal network)
		internal := v1.Group("/notifications/internal")
		{
			internal.POST("/send", notifCtrl.SendNotification) // Send notification
		}
	}
}
