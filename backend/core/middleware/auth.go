package middleware

import (
	"net/http"
	"os"
	"strings"

	"rentride/core/response"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// AuthRequired validates JWT tokens and injects user details into context
func AuthRequired() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			response.Error(c, http.StatusUnauthorized, "Authorization header missing or invalid")
			c.Abort()
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		secret := os.Getenv("JWT_ACCESS_SECRET")

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return []byte(secret), nil
		})

		if err != nil || !token.Valid {
			response.Error(c, http.StatusUnauthorized, "Invalid or expired token")
			c.Abort()
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			response.Error(c, http.StatusUnauthorized, "Invalid token claims")
			c.Abort()
			return
		}

		// Inject details into context
		c.Set("user_id", claims["user_id"])
		c.Set("role", claims["role"])
		c.Set("email", claims["email"])
		c.Next()
	}
}

// RoleRequired restricts access to specific roles
func RoleRequired(roles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		role, exists := c.Get("role")
		if !exists {
			response.Error(c, http.StatusForbidden, "Role not found in token")
			c.Abort()
			return
		}

		roleStr, ok := role.(string)
		if !ok {
			response.Error(c, http.StatusForbidden, "Invalid role format")
			c.Abort()
			return
		}

		for _, allowed := range roles {
			if roleStr == allowed {
				c.Next()
				return
			}
		}

		response.Error(c, http.StatusForbidden, "Insufficient permissions")
		c.Abort()
	}
}

// ExtractUserID is a helper to get user ID from JWT context
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

// ExtractRole is a helper to get role from JWT context
func ExtractRole(c *gin.Context) (string, bool) {
	val, exists := c.Get("role")
	if !exists {
		return "", false
	}
	return val.(string), true
}
