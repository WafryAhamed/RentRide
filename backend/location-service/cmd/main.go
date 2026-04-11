package main

import (
	"log"
	"net/http"
	"os"

	"rentride/location-service/config"
	"rentride/location-service/models"
	"rentride/location-service/routes"
	ws "rentride/location-service/websocket"

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

	// Auto migrate schema
	config.AutoMigrate(&models.DriverLocation{})

	// Initialize WebSocket Hub
	hub := ws.NewHub()
	go hub.Run()

	// Initialize router
	router := gin.Default()

	// Basic CORS
	router.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE, PATCH")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	router.GET("/api/v1/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":         "Location Service Healthy",
			"online_drivers": hub.GetOnlineDriverCount(),
		})
	})

	routes.RegisterRoutes(router, hub)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8083"
	}

	log.Printf("🚀 RentRide Location Service starting on port %s", port)
	log.Printf("📡 WebSocket endpoints: /api/v1/ws/track/:ride_id, /api/v1/ws/driver")

	if err := router.Run(":" + port); err != nil {
		log.Fatalf("❌ Failed to start server: %v", err)
	}
}
