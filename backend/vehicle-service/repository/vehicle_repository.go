package repository

import (
	"rentride/vehicle-service/config"
	"rentride/vehicle-service/models"

	"gorm.io/gorm"
)

type VehicleRepository struct {
	db *gorm.DB
}

func NewVehicleRepository() *VehicleRepository {
	return &VehicleRepository{db: config.DB}
}

// Create inserts a new vehicle and ensures other vehicles are deactivated if this one is active
func (r *VehicleRepository) Create(vehicle *models.Vehicle) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(vehicle).Error; err != nil {
			return err
		}

		if vehicle.IsActive {
			// Deactivate all other vehicles for this driver
			if err := tx.Model(&models.Vehicle{}).
				Where("driver_id = ? AND id != ?", vehicle.DriverID, vehicle.ID).
				Update("is_active", false).Error; err != nil {
				return err
			}
		}
		return nil
	})
}

// FindByDriverID returns all vehicles owned by a driver
func (r *VehicleRepository) FindByDriverID(driverID uint) ([]models.Vehicle, error) {
	var vehicles []models.Vehicle
	err := r.db.Where("driver_id = ?", driverID).Order("created_at desc").Find(&vehicles).Error
	return vehicles, err
}

// FindActiveByDriverID returns the single active vehicle for a driver
func (r *VehicleRepository) FindActiveByDriverID(driverID uint) (*models.Vehicle, error) {
	var vehicle models.Vehicle
	err := r.db.Where("driver_id = ? AND is_active = ?", driverID, true).First(&vehicle).Error
	if err != nil {
		return nil, err
	}
	return &vehicle, nil
}

func (r *VehicleRepository) Update(vehicle *models.Vehicle) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Save(vehicle).Error; err != nil {
			return err
		}

		// If this vehicle was marked active, deactivate others
		if vehicle.IsActive {
			if err := tx.Model(&models.Vehicle{}).
				Where("driver_id = ? AND id != ?", vehicle.DriverID, vehicle.ID).
				Update("is_active", false).Error; err != nil {
				return err
			}
		}
		return nil
	})
}

func (r *VehicleRepository) FindByID(id uint) (*models.Vehicle, error) {
	var vehicle models.Vehicle
	err := r.db.First(&vehicle, id).Error
	if err != nil {
		return nil, err
	}
	return &vehicle, nil
}

// GetAll returns all vehicles across the platform (Admin only)
func (r *VehicleRepository) GetAll() ([]models.Vehicle, error) {
	var vehicles []models.Vehicle
	err := r.db.Order("created_at desc").Find(&vehicles).Error
	return vehicles, err
}
