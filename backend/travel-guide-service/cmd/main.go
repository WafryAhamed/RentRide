package main

import (
	"log"
	"os"

	"rentride/core/logger"
	"rentride/core/middleware"
	
	"rentride/travel-guide-service/config"
	"rentride/travel-guide-service/controllers"
	"rentride/travel-guide-service/repository"
	"rentride/travel-guide-service/routes"
	"rentride/travel-guide-service/services"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, relying on environment variables")
	}



	db := config.ConnectDB()

	repo := repository.NewPlaceRepository(db)
	svc := services.NewGuideService(repo)
	ctrl := controllers.NewGuideController(svc)

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.RequestLogger("travel-guide-service"))
	router.Use(middleware.Recovery("travel-guide-service"))

	routes.RegisterRoutes(router, ctrl)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8087"
	}

	logger.Log.Info("Starting Travel Guide Service on port " + port)
	if err := router.Run(":" + port); err != nil {
		logger.Log.Fatal("Failed to start server: " + err.Error())
	}
}
