package routes

import (
	"net/http"

	"rentride/api-gateway/config"
	"rentride/api-gateway/proxy"

	"github.com/gin-gonic/gin"
)

// RegisterRoutes sets up all gateway route mappings
func RegisterRoutes(router *gin.Engine, urls *config.ServiceURLs) {
	v1 := router.Group("/api/v1")

	// Gateway health check
	v1.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "API Gateway Healthy",
			"gateway": true,
		})
	})

	// ── Auth Service Routes ──────────────────────────────────────
	authProxy := proxy.ServiceProxy(urls.Auth)
	v1.Any("/auth/*path", authProxy)

	// ── User Service Routes ──────────────────────────────────────
	userProxy := proxy.ServiceProxy(urls.User)
	v1.Any("/users/*path", userProxy)

	// ── Booking Service Routes ───────────────────────────────────
	bookingProxy := proxy.ServiceProxy(urls.Booking)
	v1.Any("/rides/*path", bookingProxy)

	// ── Vehicle Service Routes ───────────────────────────────────
	vehicleProxy := proxy.ServiceProxy(urls.Vehicle)
	v1.Any("/vehicles/*path", vehicleProxy)

	// ── Location Service Routes ──────────────────────────────────
	locationProxy := proxy.ServiceProxy(urls.Location)
	v1.Any("/locations/*path", locationProxy)

	// ── WebSocket Routes (Location Service) ──────────────────────
	wsProxy := proxy.WebSocketProxy(urls.Location)
	v1.GET("/ws/*path", wsProxy)

	// ── Payment Service Routes ───────────────────────────────────
	paymentProxy := proxy.ServiceProxy(urls.Payment)
	v1.Any("/payments/*path", paymentProxy)

	// ── Notification Service Routes ──────────────────────────────
	notifProxy := proxy.ServiceProxy(urls.Notification)
	v1.Any("/notifications/*path", notifProxy)

	// ── Travel Guide Service Routes ──────────────────────────────
	guideProxy := proxy.ServiceProxy(urls.TravelGuide)
	v1.Any("/guides/*path", guideProxy)

	// ── Admin Routes ─────────────────────────────────────────────
	v1.Any("/admin/users/*path", userProxy)
	v1.Any("/admin/users", userProxy)
	v1.Any("/admin/vehicles/*path", vehicleProxy)
	v1.Any("/admin/vehicles", vehicleProxy)
	v1.Any("/admin/payments/*path", paymentProxy)
	v1.Any("/admin/payments", paymentProxy)
	v1.Any("/admin/rides/*path", bookingProxy)
	v1.Any("/admin/rides", bookingProxy)
}
