package testutils

import (
	"log"

	"rentride/booking-service/config"
	"rentride/booking-service/models"

	"github.com/gin-gonic/gin"
	"github.com/glebarez/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// SetupTestDB initializes an in-memory SQLite database mapped to global config
func SetupTestDB() {
	var err error
	
	gormLogger := logger.Default.LogMode(logger.Silent)
	
	config.DB, err = gorm.Open(sqlite.Open(":memory:"), &gorm.Config{
		Logger: gormLogger,
	})
	
	if err != nil {
		log.Fatalf("Failed to connect to in-memory SQLite: %v", err)
	}

	// Auto Migrate existing models (The Ride record)
	err = config.DB.AutoMigrate(&models.Ride{})
	if err != nil {
		log.Fatalf("Failed to auto migrate: %v", err)
	}
}

// TeardownTestDB explicitly drops the connection if needed between tests
func TeardownTestDB() {
	if config.DB != nil {
		sqlDB, err := config.DB.DB()
		if err == nil {
			sqlDB.Close()
		}
	}
}

// SetupRouter creates a new isolated Gin test engine
func SetupRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	return gin.New()
}
