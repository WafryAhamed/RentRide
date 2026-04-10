package repository

import (
	"rentride/booking-service/config"
	"rentride/booking-service/models"

	"gorm.io/gorm"
)

type RideRepository struct {
	db *gorm.DB
}

func NewRideRepository() *RideRepository {
	return &RideRepository{db: config.DB}
}

// Create inserts a new ride booking
func (r *RideRepository) Create(ride *models.Ride) error {
	return r.db.Create(ride).Error
}

// Update updates an existing ride (typically status/driver assignment)
func (r *RideRepository) Update(ride *models.Ride) error {
	return r.db.Save(ride).Error
}

// FindByID fetching a specific ride by ID
func (r *RideRepository) FindByID(id uint) (*models.Ride, error) {
	var ride models.Ride
	err := r.db.First(&ride, id).Error
	if err != nil {
		return nil, err
	}
	return &ride, nil
}

// FindByUserID retrieves all rides for a specific rider
func (r *RideRepository) FindByUserID(userID uint) ([]models.Ride, error) {
	var rides []models.Ride
	err := r.db.Where("user_id = ?", userID).Order("created_at desc").Find(&rides).Error
	return rides, err
}

// FindByDriverID retrieves all rides for a specific driver
func (r *RideRepository) FindByDriverID(driverID uint) ([]models.Ride, error) {
	var rides []models.Ride
	err := r.db.Where("driver_id = ?", driverID).Order("created_at desc").Find(&rides).Error
	return rides, err
}
