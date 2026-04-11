package logger

import (
	"os"

	"github.com/sirupsen/logrus"
)

// Log is the global structured logger for RentRide services
var Log *logrus.Logger

func init() {
	Log = logrus.New()
	Log.SetOutput(os.Stdout)

	env := os.Getenv("APP_ENV")
	if env == "production" {
		Log.SetFormatter(&logrus.JSONFormatter{
			TimestampFormat: "2006-01-02T15:04:05Z07:00",
		})
		Log.SetLevel(logrus.InfoLevel)
	} else {
		Log.SetFormatter(&logrus.TextFormatter{
			FullTimestamp:   true,
			TimestampFormat: "15:04:05",
			ForceColors:    true,
		})
		Log.SetLevel(logrus.DebugLevel)
	}
}

// NewServiceLogger creates a logger with a service-specific field
func NewServiceLogger(serviceName string) *logrus.Entry {
	return Log.WithField("service", serviceName)
}
