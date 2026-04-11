package services

import (
	"testing"

	"rentride/booking-service/models"
	"rentride/booking-service/testutils"

	"github.com/stretchr/testify/assert"
)

func TestRideService_CreateBooking(t *testing.T) {
	testutils.SetupTestDB()
	defer testutils.TeardownTestDB()

	rideService := NewRideService()

	// Execution Phase
	req := models.CreateRideRequest{
		UserID:          1,
		PickupLocation:  "Colombo 01",
		DropoffLocation: "Colombo 03",
		DistanceKm:      2.5,
		VehicleCategory: "car",
	}

	res, err := rideService.CreateRide(req)

	// Assertion Phase
	assert.NoError(t, err)
	assert.NotNil(t, res)
	assert.Equal(t, uint(1), res.UserID)
	assert.Equal(t, models.RideStatusPending, res.Status)
	assert.True(t, res.EstimatedFare > 0)
}

func TestRideService_GetAllRides(t *testing.T) {
	testutils.SetupTestDB()
	defer testutils.TeardownTestDB()

	rideService := NewRideService()

	// Seed specific ride
	req := models.CreateRideRequest{
		UserID:          2,
		PickupLocation:  "Malabe",
		DropoffLocation: "Kottawa",
		DistanceKm:      10.5,
		VehicleCategory: "tuktuk",
	}
	_, _ = rideService.CreateRide(req)

	// Execution Phase
	rides, err := rideService.GetAllRides()

	// Assertion Phase
	assert.NoError(t, err)
	assert.Len(t, rides, 1)
	assert.Equal(t, "Malabe", rides[0].PickupLocation)
}
