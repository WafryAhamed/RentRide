package main

import (
	"log"
	"os"

	"rentride/user-service/config"
	"rentride/user-service/middleware"
	"rentride/user-service/routes"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

// @title           RentRide User Service API
// @version         1.0
// @description     Microservice handling user management for the RentRide platform.
// @host            localhost:8080
// @BasePath        /api/v1

func main() {
	// ── Load Environment Variables ─────────────────────────────────
	if err := godotenv.Load(); err != nil {
		log.Println("⚠️  No .env file found, using system environment variables")
	}

	// ── Set Gin Mode ───────────────────────────────────────────────
	env := os.Getenv("APP_ENV")
	if env == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	// ── Initialize Database ────────────────────────────────────────
	config.ConnectDB()
	log.Println("✅ Database connected and migrated successfully")

	// ── Initialize Router ──────────────────────────────────────────
	router := gin.Default()

	// ── Global Middleware ──────────────────────────────────────────
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.RequestLogger())

	// ── Register Routes ────────────────────────────────────────────
	routes.RegisterRoutes(router)

	// ── Start Server ───────────────────────────────────────────────
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 RentRide User Service starting on port %s", port)
	log.Printf("📍 API Base: http://localhost:%s/api/v1", port)
	log.Printf("❤️  Health Check: http://localhost:%s/api/v1/health", port)

	if err := router.Run(":" + port); err != nil {
		log.Fatalf("❌ Failed to start server: %v", err)
	}
}
