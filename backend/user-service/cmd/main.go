package main

import (
	"log"
	"os"

	"rentride/user-service/config"
	"rentride/user-service/routes"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("No .env file found, relying on system environment variables")
	}

	// Connect to Database and Auto-Migrate
	config.ConnectDB()

	// Initialize Gin router
	router := gin.Default()

	// Setup Routes
	routes.SetupRoutes(router)

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	
	log.Printf("User Service starting on port %s...", port)
	err = router.Run(":" + port)
	if err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
