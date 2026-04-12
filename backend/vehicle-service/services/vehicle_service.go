package services

import (
	"errors"

	"rentride/vehicle-service/models"
	"rentride/vehicle-service/repository"
)

type VehicleService struct {
	repo *repository.VehicleRepository
}

func NewVehicleService() *VehicleService {
	return &VehicleService{repo: repository.NewVehicleRepository()}
}

// RegisterVehicle binds a new vehicle to the driver making the request
func (s *VehicleService) RegisterVehicle(driverID uint, req models.RegisterVehicleRequest) (*models.Vehicle, error) {
	vehicle := &models.Vehicle{
		DriverID:     driverID,
		Make:         req.Make,
		Model:        req.Model,
		Year:         req.Year,
		LicensePlate: req.LicensePlate,
		Category:     req.Category,
		Color:        req.Color,
		// By default, if they check IsActive, we let the repo transaction handle disabling others
		IsActive: req.IsActive, 
	}

	if err := s.repo.Create(vehicle); err != nil {
		return nil, errors.New("failed to register vehicle. License plate might already exist")
	}

	return vehicle, nil
}

func (s *VehicleService) GetDriverVehicles(driverID uint) ([]models.Vehicle, error) {
	return s.repo.FindByDriverID(driverID)
}

func (s *VehicleService) GetActiveVehicle(driverID uint) (*models.Vehicle, error) {
	return s.repo.FindActiveByDriverID(driverID)
}

func (s *VehicleService) UpdateVehicle(driverID uint, vehicleID uint, req models.UpdateVehicleRequest) (*models.Vehicle, error) {
	vehicle, err := s.repo.FindByID(vehicleID)
	if err != nil {
		return nil, errors.New("vehicle not found")
	}

	if vehicle.DriverID != driverID {
		return nil, errors.New("you do not have permission to modify this vehicle")
	}

	if req.Make != nil {
		vehicle.Make = *req.Make
	}
	if req.Model != nil {
		vehicle.Model = *req.Model
	}
	if req.Year != nil {
		vehicle.Year = *req.Year
	}
	if req.LicensePlate != nil {
		vehicle.LicensePlate = *req.LicensePlate
	}
	if req.Category != nil {
		vehicle.Category = *req.Category
	}
	if req.Color != nil {
		vehicle.Color = *req.Color
	}
	if req.IsActive != nil {
		vehicle.IsActive = *req.IsActive
	}

	if err := s.repo.Update(vehicle); err != nil {
		return nil, errors.New("failed to update vehicle")
	}

	return vehicle, nil
}

func (s *VehicleService) GetAllVehicles() ([]models.Vehicle, error) {
	return s.repo.GetAll()
}

