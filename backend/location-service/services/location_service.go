package services

import (
	"errors"

	"rentride/location-service/models"
	"rentride/location-service/repository"
)

type LocationService struct {
	repo *repository.LocationRepository
}

func NewLocationService() *LocationService {
	return &LocationService{repo: repository.NewLocationRepository()}
}

// UpdateLocation handles inserting or updating a driver's live GPS point.
func (s *LocationService) UpdateLocation(driverID uint, req models.UpdateLocationRequest) error {
	loc := &models.DriverLocation{
		DriverID:  driverID,
		Latitude:  req.Latitude,
		Longitude: req.Longitude,
		Heading:   req.Heading,
		IsOnline:  true,
	}
	return s.repo.UpsertLocation(loc)
}

// GetNearbyDrivers passes valid search parameters down to the repo.
func (s *LocationService) GetNearbyDrivers(req models.SearchNearbyRequest) ([]models.DriverLocation, error) {
	if req.RadiusKm <= 0 {
		req.RadiusKm = 5.0 // Default 5km radius fallback
	}
	if req.RadiusKm > 50 {
		return nil, errors.New("radius exceeds maximum limit of 50 km")
	}

	return s.repo.FindNearbyDrivers(req.Latitude, req.Longitude, req.RadiusKm)
}
