package controllers

import (
	"net/http"
	"strconv"

	"rentride/payment-service/models"
	"rentride/payment-service/services"

	"github.com/gin-gonic/gin"
)

type PaymentController struct {
	service *services.PaymentService
}

func NewPaymentController() *PaymentController {
	return &PaymentController{service: services.NewPaymentService()}
}

// ExtractUserID is a helper that gets the parsed int from JWT context
func ExtractUserID(c *gin.Context) (uint, bool) {
	val, exists := c.Get("user_id")
	if !exists {
		return 0, false
	}
	if fval, ok := val.(float64); ok {
		return uint(fval), true
	}
	return val.(uint), true
}

// CreatePayment creates a payment record for a completed ride
func (ctrl *PaymentController) CreatePayment(c *gin.Context) {
	var req models.CreatePaymentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": err.Error()})
		return
	}

	payment, err := ctrl.service.CreatePayment(req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Payment created", "data": payment})
}

// CollectPayment marks cash as collected by driver
func (ctrl *PaymentController) CollectPayment(c *gin.Context) {
	driverID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	paymentID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": "Invalid payment ID"})
		return
	}

	var req models.CollectPaymentRequest
	_ = c.ShouldBindJSON(&req) // Notes are optional

	payment, err := ctrl.service.CollectPayment(uint(paymentID), driverID, req.Notes)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Cash collected", "data": payment})
}

// ConfirmPayment user confirms cash was handed over
func (ctrl *PaymentController) ConfirmPayment(c *gin.Context) {
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	paymentID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": "Invalid payment ID"})
		return
	}

	payment, err := ctrl.service.ConfirmPayment(uint(paymentID), userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Payment confirmed", "data": payment})
}

// GetPaymentByRide fetches payment for a ride
func (ctrl *PaymentController) GetPaymentByRide(c *gin.Context) {
	rideID, err := strconv.ParseUint(c.Param("ride_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "error": "Invalid ride ID"})
		return
	}

	payment, err := ctrl.service.GetPaymentByRideID(uint(rideID))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"success": false, "error": "Payment not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": payment})
}

// GetPaymentHistory fetches user's payment history
func (ctrl *PaymentController) GetPaymentHistory(c *gin.Context) {
	userID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	payments, err := ctrl.service.GetUserPaymentHistory(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": "Failed to fetch payments"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": payments})
}

// GetDriverEarnings fetches driver's total earnings
func (ctrl *PaymentController) GetDriverEarnings(c *gin.Context) {
	driverID, ok := ExtractUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "error": "Unauthorized"})
		return
	}

	earnings, err := ctrl.service.GetDriverEarnings(driverID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": "Failed to fetch earnings"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": gin.H{"total_earnings": earnings}})
}
