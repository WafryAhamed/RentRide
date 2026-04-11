package controllers

import (
	"net/http"
	"strconv"

	"rentride/notification-service/models"
	"rentride/notification-service/services"

	"github.com/gin-gonic/gin"
)

type NotificationController struct {
	service *services.NotificationService
}

func NewNotificationController() *NotificationController {
	return &NotificationController{service: services.NewNotificationService()}
}

// ExtractUserID is a helper that gets the parsed int from JWT context
func ExtractUserID(c *gin.Context) (uint, bool) {
	val, exists := c.Get("user_id")
	if !exists {
		return 0, false
	}
	if fval, ok := val.(float64); ok {
		return uint(fval), true
	}
	return val.(uint), true
}

// GetNotifications fetches user's notifications
func (ctrl *NotificationController) GetNotifications(c *gin.Context) {
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	limitStr := c.DefaultQuery("limit", "50")
	limit, _ := strconv.Atoi(limitStr)

	notifications, err := ctrl.service.GetUserNotifications(userID, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": "Failed to fetch notifications"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": notifications})
}

// GetUnreadCount fetches unread notification count
func (ctrl *NotificationController) GetUnreadCount(c *gin.Context) {
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	count, err := ctrl.service.GetUnreadCount(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": "Failed to count notifications"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": gin.H{"unread_count": count}})
}

// MarkAsRead marks a single notification as read
func (ctrl *NotificationController) MarkAsRead(c *gin.Context) {
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	notifID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": "Invalid notification ID"})
		return
	}

	if err := ctrl.service.MarkAsRead(uint(notifID), userID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": "Failed to mark as read"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Notification marked as read"})
}

// MarkAllAsRead marks all notifications as read
func (ctrl *NotificationController) MarkAllAsRead(c *gin.Context) {
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	if err := ctrl.service.MarkAllAsRead(userID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": "Failed to mark all as read"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "message": "All notifications marked as read"})
}

// SendNotification is an internal endpoint called by other services
func (ctrl *NotificationController) SendNotification(c *gin.Context) {
	var req models.SendNotificationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": err.Error()})
		return
	}

	notification, err := ctrl.service.SendNotification(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Notification sent", "data": notification})
}
