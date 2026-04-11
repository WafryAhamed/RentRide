package testutils

import (
	"log"
	"os"

	"rentride/auth-service/config"
	"rentride/auth-service/models"

	"github.com/gin-gonic/gin"
	"github.com/glebarez/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// SetupTestEnv injects testing environment variables
func SetupTestEnv() {
	os.Setenv("JWT_ACCESS_SECRET", "test-secret")
	os.Setenv("JWT_REFRESH_SECRET", "test-refresh-secret")
}

// SetupTestDB initializes an in-memory SQLite database mapped to global config
func SetupTestDB() {
	var err error
	
	// Disable GORM logs during tests to keep console clean
	gormLogger := logger.Default.LogMode(logger.Silent)
	
	config.DB, err = gorm.Open(sqlite.Open(":memory:"), &gorm.Config{
		Logger: gormLogger,
	})
	
	if err != nil {
		log.Fatalf("Failed to connect to in-memory SQLite: %v", err)
	}

	// Auto Migrate existing models
	err = config.DB.AutoMigrate(&models.User{}, &models.RefreshToken{})
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
