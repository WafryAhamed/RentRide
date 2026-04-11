package routes

import (
	"rentride/payment-service/controllers"
	"rentride/payment-service/middleware"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine) {
	v1 := router.Group("/api/v1")
	{
		payCtrl := controllers.NewPaymentController()

		payments := v1.Group("/payments")
		payments.Use(middleware.AuthRequired())
		{
			payments.POST("", payCtrl.CreatePayment)                  // Create payment for ride
			payments.PATCH("/:id/collect", payCtrl.CollectPayment)    // Driver collects cash
			payments.PATCH("/:id/confirm", payCtrl.ConfirmPayment)    // User confirms payment
			payments.GET("/ride/:ride_id", payCtrl.GetPaymentByRide)  // Get payment by ride
			payments.GET("/history", payCtrl.GetPaymentHistory)       // User payment history
			payments.GET("/earnings", payCtrl.GetDriverEarnings)      // Driver earnings
		}
	}
}
