package services

import (
	"errors"
	"time"

	"rentride/payment-service/models"
	"rentride/payment-service/repository"
)

type PaymentService struct {
	repo *repository.PaymentRepository
}

func NewPaymentService() *PaymentService {
	return &PaymentService{repo: repository.NewPaymentRepository()}
}

// CreatePayment creates a new cash payment record when a ride is completed
func (s *PaymentService) CreatePayment(req models.CreatePaymentRequest) (*models.Payment, error) {
	// Check if payment already exists for this ride
	existing, _ := s.repo.FindByRideID(req.RideID)
	if existing != nil {
		return nil, errors.New("payment already exists for this ride")
	}

	payment := &models.Payment{
		RideID:        req.RideID,
		UserID:        req.UserID,
		DriverID:      req.DriverID,
		Amount:        req.Amount,
		PaymentMethod: models.MethodCash,
		Status:        models.PaymentPending,
	}

	if err := s.repo.Create(payment); err != nil {
		return nil, errors.New("failed to create payment record")
	}

	return payment, nil
}

// CollectPayment marks a cash payment as collected by the driver
func (s *PaymentService) CollectPayment(paymentID uint, driverID uint, notes string) (*models.Payment, error) {
	payment, err := s.repo.FindByID(paymentID)
	if err != nil {
		return nil, errors.New("payment not found")
	}

	if payment.DriverID != driverID {
		return nil, errors.New("only the assigned driver can collect this payment")
	}

	if payment.Status != models.PaymentPending {
		return nil, errors.New("payment is not in pending state")
	}

	now := time.Now()
	payment.Status = models.PaymentCollected
	payment.CollectedAt = &now
	payment.Notes = notes

	if err := s.repo.Update(payment); err != nil {
		return nil, errors.New("failed to update payment status")
	}

	return payment, nil
}

// ConfirmPayment confirms the cash payment by the user
func (s *PaymentService) ConfirmPayment(paymentID uint, userID uint) (*models.Payment, error) {
	payment, err := s.repo.FindByID(paymentID)
	if err != nil {
		return nil, errors.New("payment not found")
	}

	if payment.UserID != userID {
		return nil, errors.New("only the ride user can confirm this payment")
	}

	if payment.Status != models.PaymentCollected {
		return nil, errors.New("payment must be collected before confirming")
	}

	now := time.Now()
	payment.Status = models.PaymentConfirmed
	payment.ConfirmedAt = &now

	if err := s.repo.Update(payment); err != nil {
		return nil, errors.New("failed to confirm payment")
	}

	return payment, nil
}

// GetPaymentByRideID fetches payment for a specific ride
func (s *PaymentService) GetPaymentByRideID(rideID uint) (*models.Payment, error) {
	return s.repo.FindByRideID(rideID)
}

// GetUserPaymentHistory fetches all payments for a user
func (s *PaymentService) GetUserPaymentHistory(userID uint) ([]models.Payment, error) {
	return s.repo.FindByUserID(userID)
}

// GetDriverPaymentHistory fetches all payments for a driver
func (s *PaymentService) GetDriverPaymentHistory(driverID uint) ([]models.Payment, error) {
	return s.repo.FindByDriverID(driverID)
}

// GetDriverEarnings calculates total earnings for a driver
func (s *PaymentService) GetDriverEarnings(driverID uint) (float64, error) {
	return s.repo.GetDriverEarnings(driverID)
}

func (s *PaymentService) GetAllPayments() ([]models.Payment, error) {
	return s.repo.GetAll()
}

func (s *PaymentService) SimulateQRWebhook(paymentID uint) (*models.Payment, error) {
	payment, err := s.repo.FindByID(paymentID)
	if err != nil {
		return nil, errors.New("payment not found")
	}

	now := time.Now()
	payment.Status = models.PaymentConfirmed
	payment.ConfirmedAt = &now
	payment.PaymentMethod = models.MethodQR

	if err := s.repo.Update(payment); err != nil {
		return nil, errors.New("failed to simulate QR payment")
	}

	return payment, nil
}
