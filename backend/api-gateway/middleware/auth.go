package middleware

import (
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// PublicPaths are paths that don't require authentication
var PublicPaths = []string{
	"/api/v1/auth/login",
	"/api/v1/auth/register",
	"/api/v1/auth/refresh",
	"/api/v1/health",
}

// AuthMiddleware validates JWT tokens at the gateway level
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Skip CORS preflight
		if c.Request.Method == "OPTIONS" {
			c.Next()
			return
		}

		// Skip auth for public paths
		path := c.Request.URL.Path
		for _, publicPath := range PublicPaths {
			if path == publicPath || strings.HasPrefix(path, publicPath) {
				c.Next()
				return
			}
		}

		// Also skip for health checks on each service
		if strings.HasSuffix(path, "/health") {
			c.Next()
			return
		}

		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			c.JSON(http.StatusUnauthorized, gin.H{
				"success": false,
				"error":   "Authorization header missing or invalid",
			})
			c.Abort()
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		secret := os.Getenv("JWT_ACCESS_SECRET")

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return []byte(secret), nil
		})

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{
				"success": false,
				"error":   "Invalid or expired token",
			})
			c.Abort()
			return
		}

		// Token is valid, forward to the service
		c.Next()
	}
}
