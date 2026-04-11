package middleware

import (
	"net/http"
	"runtime/debug"

	"rentride/core/logger"
	"rentride/core/response"

	"github.com/gin-gonic/gin"
)

// Recovery handles panics and returns a structured error response
func Recovery(serviceName string) gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				logger.Log.WithField("service", serviceName).
					WithField("path", c.Request.URL.Path).
					WithField("stack", string(debug.Stack())).
					Errorf("Panic recovered: %v", err)

				response.Error(c, http.StatusInternalServerError, "An unexpected error occurred")
				c.Abort()
			}
		}()
		c.Next()
	}
}
