package main

import (
	"log"
	"net/http"
	"os"

	"rentride/auth-service/config"
	"rentride/auth-service/models"
	"rentride/auth-service/routes"

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

	// Connect to Database
	config.ConnectDB()

	// Auto migrate auth specific schemas (like RefreshToken)
	config.AutoMigrate(&models.RefreshToken{})

	// Initialize Gin router
	router := gin.Default()

	// Basic CORS (assuming similar to user service middleware, hardcoded for simplicity right now)
	router.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Setup health check
	router.GET("/api/v1/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "Auth Service Healthy"})
	})

	// Setup Auth Routes
	routes.RegisterRoutes(router)

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8081"
	}

	log.Printf("🚀 RentRide Auth Service starting on port %s", port)
	
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("❌ Failed to start server: %v", err)
	}
}
