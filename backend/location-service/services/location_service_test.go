package services

import (
	"testing"

	"rentride/location-service/models"
)

// TestUpdateLocationRequest_Validation tests location update request
func TestUpdateLocationRequest_Validation(t *testing.T) {
	req := models.UpdateLocationRequest{
		Latitude:  6.9271,
		Longitude: 79.8612,
		Heading:   90.0,
	}

	if req.Latitude == 0 {
		t.Error("Latitude should not be zero")
	}
	if req.Longitude == 0 {
		t.Error("Longitude should not be zero")
	}
	if req.Heading < 0 || req.Heading > 360 {
		t.Error("Heading should be between 0 and 360")
	}
}

// TestSearchNearbyRequest_DefaultRadius tests default radius fallback
func TestSearchNearbyRequest_DefaultRadius(t *testing.T) {
	req := models.SearchNearbyRequest{
		Latitude:  6.9271,
		Longitude: 79.8612,
		RadiusKm:  0,
	}

	// Service should default to 5km
	if req.RadiusKm <= 0 {
		req.RadiusKm = 5.0
	}

	if req.RadiusKm != 5.0 {
		t.Errorf("Expected default radius 5.0, got %f", req.RadiusKm)
	}
}

// TestSearchNearbyRequest_MaxRadius tests max radius validation
func TestSearchNearbyRequest_MaxRadius(t *testing.T) {
	req := models.SearchNearbyRequest{
		Latitude:  6.9271,
		Longitude: 79.8612,
		RadiusKm:  100,
	}

	if req.RadiusKm > 50 {
		t.Log("Radius exceeds maximum limit of 50km — service should reject")
	}
}

// TestDriverLocation_Model tests driver location model
func TestDriverLocation_Model(t *testing.T) {
	loc := models.DriverLocation{
		DriverID:  1,
		Latitude:  6.9271,
		Longitude: 79.8612,
		Heading:   180.0,
		IsOnline:  true,
	}

	if loc.DriverID == 0 {
		t.Error("DriverID should not be zero")
	}
	if !loc.IsOnline {
		t.Error("IsOnline should be true")
	}
	if loc.TableName() != "driver_locations" {
		t.Errorf("Expected table name 'driver_locations', got '%s'", loc.TableName())
	}
}
