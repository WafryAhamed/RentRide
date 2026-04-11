package repository

import (
	"rentride/payment-service/config"
	"rentride/payment-service/models"

	"gorm.io/gorm"
)

type PaymentRepository struct {
	db *gorm.DB
}

func NewPaymentRepository() *PaymentRepository {
	return &PaymentRepository{db: config.DB}
}

// Create inserts a new payment record
func (r *PaymentRepository) Create(payment *models.Payment) error {
	return r.db.Create(payment).Error
}

// Update saves changes to a payment record
func (r *PaymentRepository) Update(payment *models.Payment) error {
	return r.db.Save(payment).Error
}

// FindByID fetches a payment by ID
func (r *PaymentRepository) FindByID(id uint) (*models.Payment, error) {
	var payment models.Payment
	err := r.db.First(&payment, id).Error
	if err != nil {
		return nil, err
	}
	return &payment, nil
}

// FindByRideID fetches a payment for a specific ride
func (r *PaymentRepository) FindByRideID(rideID uint) (*models.Payment, error) {
	var payment models.Payment
	err := r.db.Where("ride_id = ?", rideID).First(&payment).Error
	if err != nil {
		return nil, err
	}
	return &payment, nil
}

// FindByUserID fetches all payments for a user
func (r *PaymentRepository) FindByUserID(userID uint) ([]models.Payment, error) {
	var payments []models.Payment
	err := r.db.Where("user_id = ?", userID).Order("created_at desc").Find(&payments).Error
	return payments, err
}

// FindByDriverID fetches all payments for a driver
func (r *PaymentRepository) FindByDriverID(driverID uint) ([]models.Payment, error) {
	var payments []models.Payment
	err := r.db.Where("driver_id = ?", driverID).Order("created_at desc").Find(&payments).Error
	return payments, err
}

// GetDriverEarnings calculates total earnings for a driver
func (r *PaymentRepository) GetDriverEarnings(driverID uint) (float64, error) {
	var total float64
	err := r.db.Model(&models.Payment{}).
		Where("driver_id = ? AND status IN ?", driverID, []string{"COLLECTED", "CONFIRMED"}).
		Select("COALESCE(SUM(amount), 0)").
		Scan(&total).Error
	return total, err
}
