package httpclient

import "os"

// Services is the service registry mapping service names to base URLs
var Services = map[string]string{
	"auth":         getEnvOrDefault("AUTH_SERVICE_URL", "http://localhost:8081"),
	"user":         getEnvOrDefault("USER_SERVICE_URL", "http://localhost:8080"),
	"booking":      getEnvOrDefault("BOOKING_SERVICE_URL", "http://localhost:8082"),
	"location":     getEnvOrDefault("LOCATION_SERVICE_URL", "http://localhost:8083"),
	"vehicle":      getEnvOrDefault("VEHICLE_SERVICE_URL", "http://localhost:8084"),
	"payment":      getEnvOrDefault("PAYMENT_SERVICE_URL", "http://localhost:8085"),
	"notification": getEnvOrDefault("NOTIFICATION_SERVICE_URL", "http://localhost:8086"),
}

func getEnvOrDefault(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}
