package config

import (
	"fmt"
	"log"
	"os"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var DB *gorm.DB

func ConnectDB() {
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")

	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Asia/Colombo",
		host, user, password, dbname, port,
	)

	gormLogger := logger.Default.LogMode(logger.Info)
	if os.Getenv("APP_ENV") == "production" {
		gormLogger = logger.Default.LogMode(logger.Error)
	}

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger:  gormLogger,
		NowFunc: func() time.Time { return time.Now().UTC() },
	})

	if err != nil {
		log.Fatalf("❌ Failed to connect to PostgreSQL (Payment Service): %v", err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		log.Fatalf("❌ Failed to process DB instance: %v", err)
	}

	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)
	sqlDB.SetConnMaxLifetime(time.Hour)

	DB = db
	log.Println("✅ Payment Service connected to Database")
}

func AutoMigrate(models ...interface{}) {
	if err := DB.AutoMigrate(models...); err != nil {
		log.Fatalf("❌ Auto-migration failed: %v", err)
	}
	log.Println("✅ Database auto-migration completed for Payment Service")
}
