package config

import (
	"os"
)

// ServiceURLs holds the base URLs for all backend services
type ServiceURLs struct {
	Auth         string
	User         string
	Booking      string
	Location     string
	Vehicle      string
	Payment      string
	Notification string
}

// LoadServiceURLs reads service URLs from environment variables
func LoadServiceURLs() *ServiceURLs {
	return &ServiceURLs{
		Auth:         getEnvOrDefault("AUTH_SERVICE_URL", "http://localhost:8081"),
		User:         getEnvOrDefault("USER_SERVICE_URL", "http://localhost:8080"),
		Booking:      getEnvOrDefault("BOOKING_SERVICE_URL", "http://localhost:8082"),
		Location:     getEnvOrDefault("LOCATION_SERVICE_URL", "http://localhost:8083"),
		Vehicle:      getEnvOrDefault("VEHICLE_SERVICE_URL", "http://localhost:8084"),
		Payment:      getEnvOrDefault("PAYMENT_SERVICE_URL", "http://localhost:8085"),
		Notification: getEnvOrDefault("NOTIFICATION_SERVICE_URL", "http://localhost:8086"),
	}
}

func getEnvOrDefault(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}
