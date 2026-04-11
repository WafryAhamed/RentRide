package services

import (
	"errors"
	"math"
	"math/rand"
	"time"

	"rentride/booking-service/models"
	"rentride/booking-service/repository"
)

type RideService struct {
	repo *repository.RideRepository
}

func NewRideService() *RideService {
	return &RideService{repo: repository.NewRideRepository()}
}

// RequestRide creates a new booking for a user.
func (s *RideService) RequestRide(userID uint, req models.CreateRideRequest) (*models.Ride, error) {
	// Simple distance mock calculation
	latDiff := req.DropoffLat - req.PickupLat
	lngDiff := req.DropoffLng - req.PickupLng
	distanceKm := math.Sqrt(latDiff*latDiff + lngDiff*lngDiff) * 111.0 
	
	if distanceKm < 0.5 {
		distanceKm = 0.5 + (rand.Float64() * 2) 
	}

	// Fake fare calculation: base 200 LKR + 100 LKR per KM
	fare := 200.0 + (distanceKm * 100.0)
	duration := int(distanceKm * 3.5) // ~3.5 mins per km in city traffic

	ride := &models.Ride{
		UserID:      userID,
		PickupLat:   req.PickupLat,
		PickupLng:   req.PickupLng,
		PickupLoc:   req.PickupLoc,
		DropoffLat:  req.DropoffLat,
		DropoffLng:  req.DropoffLng,
		DropoffLoc:  req.DropoffLoc,
		Status:      models.StatusPending,
		Fare:        fare,
		DistanceKm:  distanceKm,
		DurationMin: duration,
	}

	if err := s.repo.Create(ride); err != nil {
		return nil, errors.New("failed to request ride")
	}

	return ride, nil
}

// UpdateRideStatus transitions the ride state
func (s *RideService) UpdateRideStatus(rideID uint, driverID *uint, newStatus models.RideStatus) (*models.Ride, error) {
	ride, err := s.repo.FindByID(rideID)
	if err != nil {
		return nil, errors.New("ride not found")
	}

	ride.Status = newStatus
	
	// Assign driver if moving to accepted
	if newStatus == models.StatusAccepted && driverID != nil {
		ride.DriverID = driverID
	}

	// Capture timestamps
	now := time.Now()
	if newStatus == models.StatusInProgress {
		ride.StartedAt = &now
	}
	if newStatus == models.StatusCompleted {
		ride.CompletedAt = &now
	}

	if err := s.repo.Update(ride); err != nil {
		return nil, errors.New("failed to update ride status")
	}

	return ride, nil
}

func (s *RideService) GetRideByID(id uint) (*models.Ride, error) {
	return s.repo.FindByID(id)
}

func (s *RideService) GetUserHistory(userID uint) ([]models.Ride, error) {
	return s.repo.FindByUserID(userID)
}

func (s *RideService) GetAllRides() ([]models.Ride, error) {
	return s.repo.GetAll()
}

func (s *RideService) GetDriverHistory(driverID uint) ([]models.Ride, error) {
	return s.repo.FindByDriverID(driverID)
}
