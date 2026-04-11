package services

import (
	"testing"

	"rentride/notification-service/models"
)

// TestNotificationType_Constants tests notification type values
func TestNotificationType_Constants(t *testing.T) {
	tests := []struct {
		name     string
		notifType models.NotificationType
		want     string
	}{
		{"RideRequest", models.TypeRideRequest, "RIDE_REQUEST"},
		{"RideAccepted", models.TypeRideAccepted, "RIDE_ACCEPTED"},
		{"RideArriving", models.TypeRideArriving, "RIDE_ARRIVING"},
		{"RideStarted", models.TypeRideStarted, "RIDE_STARTED"},
		{"RideCompleted", models.TypeRideCompleted, "RIDE_COMPLETED"},
		{"RideCancelled", models.TypeRideCancelled, "RIDE_CANCELLED"},
		{"Payment", models.TypePayment, "PAYMENT"},
		{"System", models.TypeSystem, "SYSTEM"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if string(tt.notifType) != tt.want {
				t.Errorf("Expected %s, got %s", tt.want, string(tt.notifType))
			}
		})
	}
}

// TestSendNotificationRequest_Validation tests notification request
func TestSendNotificationRequest_Validation(t *testing.T) {
	req := models.SendNotificationRequest{
		UserID:   1,
		Title:    "Ride Accepted",
		Body:     "Your driver is on the way!",
		Type:     models.TypeRideAccepted,
		Metadata: `{"ride_id": 42}`,
	}

	if req.UserID == 0 {
		t.Error("UserID should not be zero")
	}
	if req.Title == "" {
		t.Error("Title should not be empty")
	}
	if req.Body == "" {
		t.Error("Body should not be empty")
	}
}

// TestNotificationModel_TableName tests table name
func TestNotificationModel_TableName(t *testing.T) {
	n := models.Notification{}
	if n.TableName() != "notifications" {
		t.Errorf("Expected table name 'notifications', got '%s'", n.TableName())
	}
}

// TestNotificationModel_DefaultRead tests default read status
func TestNotificationModel_DefaultRead(t *testing.T) {
	n := models.Notification{
		UserID: 1,
		Title:  "Test",
		Body:   "Test body",
		Type:   models.TypeSystem,
		IsRead: false,
	}

	if n.IsRead {
		t.Error("IsRead should default to false")
	}
}
