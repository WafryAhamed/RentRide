package main

import (
	"log"
	"os"
	"strconv"

	"rentride/api-gateway/config"
	"rentride/api-gateway/middleware"
	"rentride/api-gateway/routes"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("⚠️  No .env file found, using system environment variables")
	}

	env := os.Getenv("APP_ENV")
	if env == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	// Load service URLs
	serviceURLs := config.LoadServiceURLs()

	// Initialize router
	router := gin.Default()

	// ── Global Middleware ──────────────────────────────────────
	// CORS
	router.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With, X-Request-ID")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE, PATCH")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Rate limiting
	rps := 100
	if rpsStr := os.Getenv("RATE_LIMIT_RPS"); rpsStr != "" {
		if parsed, err := strconv.Atoi(rpsStr); err == nil {
			rps = parsed
		}
	}
	rateLimiter := middleware.NewRateLimiter(rps)
	router.Use(rateLimiter.RateLimit())

	// Auth validation at gateway level
	router.Use(middleware.AuthMiddleware())

	// ── Register Routes ───────────────────────────────────────
	routes.RegisterRoutes(router, serviceURLs)

	// ── Start Server ──────────────────────────────────────────
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	log.Printf("🚀 RentRide API Gateway starting on port %s", port)
	log.Printf("📍 Gateway: http://localhost:%s/api/v1", port)
	log.Printf("🔗 Proxying to services:")
	log.Printf("   Auth:         %s", serviceURLs.Auth)
	log.Printf("   User:         %s", serviceURLs.User)
	log.Printf("   Booking:      %s", serviceURLs.Booking)
	log.Printf("   Location:     %s", serviceURLs.Location)
	log.Printf("   Vehicle:      %s", serviceURLs.Vehicle)
	log.Printf("   Payment:      %s", serviceURLs.Payment)
	log.Printf("   Notification: %s", serviceURLs.Notification)

	if err := router.Run(":" + port); err != nil {
		log.Fatalf("❌ Failed to start API Gateway: %v", err)
	}
}
