package middleware

import (
	"time"

	"rentride/core/logger"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

// RequestLogger logs request details with structured fields
func RequestLogger(serviceName string) gin.HandlerFunc {
	return func(c *gin.Context) {
		startTime := time.Now()
		path := c.Request.URL.Path
		method := c.Request.Method

		// Process request
		c.Next()

		// Calculate latency
		latency := time.Since(startTime)
		statusCode := c.Writer.Status()

		entry := logger.Log.WithFields(logrus.Fields{
			"service":  serviceName,
			"method":   method,
			"path":     path,
			"status":   statusCode,
			"latency":  latency.String(),
			"ip":       c.ClientIP(),
		})

		// Add user_id if authenticated
		if userID, exists := c.Get("user_id"); exists {
			entry = entry.WithField("user_id", userID)
		}

		// Add request ID if present
		if reqID := c.GetHeader("X-Request-ID"); reqID != "" {
			entry = entry.WithField("request_id", reqID)
		}

		if statusCode >= 500 {
			entry.Error("Server error")
		} else if statusCode >= 400 {
			entry.Warn("Client error")
		} else {
			entry.Info("Request completed")
		}
	}
}
