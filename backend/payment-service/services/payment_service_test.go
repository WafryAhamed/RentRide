package services

import (
	"testing"

	"rentride/payment-service/models"
)

// TestPaymentStatus_Constants tests payment status values
func TestPaymentStatus_Constants(t *testing.T) {
	tests := []struct {
		name   string
		status models.PaymentStatus
		want   string
	}{
		{"Pending", models.PaymentPending, "PENDING"},
		{"Collected", models.PaymentCollected, "COLLECTED"},
		{"Confirmed", models.PaymentConfirmed, "CONFIRMED"},
		{"Cancelled", models.PaymentCancelled, "CANCELLED"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if string(tt.status) != tt.want {
				t.Errorf("Expected %s, got %s", tt.want, string(tt.status))
			}
		})
	}
}

// TestPaymentMethod_CashOnly tests that only CASH method is available
func TestPaymentMethod_CashOnly(t *testing.T) {
	if string(models.MethodCash) != "CASH" {
		t.Errorf("Expected CASH, got %s", string(models.MethodCash))
	}
}

// TestCreatePaymentRequest_Validation tests payment creation request
func TestCreatePaymentRequest_Validation(t *testing.T) {
	req := models.CreatePaymentRequest{
		RideID:   1,
		UserID:   10,
		DriverID: 20,
		Amount:   450.00,
	}

	if req.RideID == 0 {
		t.Error("RideID should not be zero")
	}
	if req.UserID == 0 {
		t.Error("UserID should not be zero")
	}
	if req.DriverID == 0 {
		t.Error("DriverID should not be zero")
	}
	if req.Amount <= 0 {
		t.Error("Amount should be positive")
	}
}

// TestPaymentModel_TableName tests the table name
func TestPaymentModel_TableName(t *testing.T) {
	p := models.Payment{}
	if p.TableName() != "payments" {
		t.Errorf("Expected table name 'payments', got '%s'", p.TableName())
	}
}

// TestPaymentModel_DefaultValues tests default model values
func TestPaymentModel_DefaultValues(t *testing.T) {
	p := models.Payment{
		RideID:        1,
		UserID:        10,
		DriverID:      20,
		Amount:        500.00,
		PaymentMethod: models.MethodCash,
		Status:        models.PaymentPending,
	}

	if p.PaymentMethod != models.MethodCash {
		t.Errorf("Expected CASH payment method, got %s", string(p.PaymentMethod))
	}
	if p.Status != models.PaymentPending {
		t.Errorf("Expected PENDING status, got %s", string(p.Status))
	}
	if p.CollectedAt != nil {
		t.Error("CollectedAt should be nil initially")
	}
	if p.ConfirmedAt != nil {
		t.Error("ConfirmedAt should be nil initially")
	}
}
