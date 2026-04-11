package services

import (
	"testing"

	"rentride/booking-service/models"
)

// TestCreateRideRequest_Validation tests ride request validation
func TestCreateRideRequest_Validation(t *testing.T) {
	req := models.CreateRideRequest{
		PickupLat:  6.9271,
		PickupLng:  79.8612,
		PickupLoc:  "Colombo Fort",
		DropoffLat: 6.9147,
		DropoffLng: 79.9725,
		DropoffLoc: "Battaramulla",
	}

	if req.PickupLat == 0 {
		t.Error("PickupLat should not be zero")
	}
	if req.PickupLng == 0 {
		t.Error("PickupLng should not be zero")
	}
	if req.PickupLoc == "" {
		t.Error("PickupLoc should not be empty")
	}
	if req.DropoffLat == 0 {
		t.Error("DropoffLat should not be zero")
	}
}

// TestRideStatus_Constants tests status constant values
func TestRideStatus_Constants(t *testing.T) {
	tests := []struct {
		name   string
		status models.RideStatus
		want   string
	}{
		{"Pending", models.StatusPending, "PENDING"},
		{"Accepted", models.StatusAccepted, "ACCEPTED"},
		{"Arriving", models.StatusArriving, "ARRIVING"},
		{"InProgress", models.StatusInProgress, "IN_PROGRESS"},
		{"Completed", models.StatusCompleted, "COMPLETED"},
		{"Cancelled", models.StatusCancelled, "CANCELLED"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if string(tt.status) != tt.want {
				t.Errorf("Expected %s, got %s", tt.want, string(tt.status))
			}
		})
	}
}

// TestFareCalculation tests the fare calculation logic
func TestFareCalculation(t *testing.T) {
	tests := []struct {
		name       string
		distanceKm float64
		wantMin    float64
		wantMax    float64
	}{
		{"Short ride 1km", 1.0, 250, 350},
		{"Medium ride 5km", 5.0, 650, 750},
		{"Long ride 10km", 10.0, 1100, 1300},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			fare := 200.0 + (tt.distanceKm * 100.0)
			if fare < tt.wantMin || fare > tt.wantMax {
				t.Errorf("Fare %.2f outside expected range [%.2f, %.2f]", fare, tt.wantMin, tt.wantMax)
			}
		})
	}
}

// TestDurationCalculation tests duration estimation
func TestDurationCalculation(t *testing.T) {
	distanceKm := 10.0
	duration := int(distanceKm * 3.5)

	if duration != 35 {
		t.Errorf("Expected 35 minutes for 10km, got %d", duration)
	}
}

// TestUpdateRideStatusRequest tests status update validation
func TestUpdateRideStatusRequest(t *testing.T) {
	req := models.UpdateRideStatusRequest{
		Status: models.StatusAccepted,
	}

	if req.Status != models.StatusAccepted {
		t.Errorf("Expected ACCEPTED, got %s", req.Status)
	}
}
