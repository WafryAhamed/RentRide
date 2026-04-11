package response

import (
	"time"

	"github.com/gin-gonic/gin"
)

// APIResponse is the unified response envelope for all RentRide services
type APIResponse struct {
	Success   bool        `json:"success"`
	Message   string      `json:"message,omitempty"`
	Data      interface{} `json:"data,omitempty"`
	Error     interface{} `json:"error,omitempty"`
	Timestamp string      `json:"timestamp"`
}

// Success sends a successful JSON response
func Success(c *gin.Context, statusCode int, message string, data interface{}) {
	c.JSON(statusCode, APIResponse{
		Success:   true,
		Message:   message,
		Data:      data,
		Timestamp: time.Now().UTC().Format(time.RFC3339),
	})
}

// Error sends an error JSON response
func Error(c *gin.Context, statusCode int, message string) {
	c.JSON(statusCode, APIResponse{
		Success:   false,
		Error:     message,
		Timestamp: time.Now().UTC().Format(time.RFC3339),
	})
}

// ValidationError sends a validation error response with field details
func ValidationError(c *gin.Context, statusCode int, message string, details interface{}) {
	c.JSON(statusCode, APIResponse{
		Success:   false,
		Message:   message,
		Error:     details,
		Timestamp: time.Now().UTC().Format(time.RFC3339),
	})
}

// Paginated sends a paginated success response
func Paginated(c *gin.Context, statusCode int, message string, data interface{}, total int64, page, pageSize int) {
	c.JSON(statusCode, gin.H{
		"success":   true,
		"message":   message,
		"data":      data,
		"total":     total,
		"page":      page,
		"page_size": pageSize,
		"timestamp": time.Now().UTC().Format(time.RFC3339),
	})
}
