package proxy

import (
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"strings"

	"github.com/gin-gonic/gin"
)

// ServiceProxy creates a reverse proxy handler for a target service
func ServiceProxy(targetURL string) gin.HandlerFunc {
	target, err := url.Parse(targetURL)
	if err != nil {
		log.Fatalf("❌ Invalid service URL: %s - %v", targetURL, err)
	}

	proxy := httputil.NewSingleHostReverseProxy(target)

	// Strip backend CORS headers to prevent duplicates since the Gateway handles CORS
	proxy.ModifyResponse = func(r *http.Response) error {
		r.Header.Del("Access-Control-Allow-Origin")
		r.Header.Del("Access-Control-Allow-Credentials")
		r.Header.Del("Access-Control-Allow-Methods")
		r.Header.Del("Access-Control-Allow-Headers")
		return nil
	}

	// Custom error handler
	proxy.ErrorHandler = func(w http.ResponseWriter, r *http.Request, err error) {
		log.Printf("⚠️  Proxy error for %s: %v", r.URL.Path, err)
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusBadGateway)
		w.Write([]byte(`{"success":false,"error":"Service temporarily unavailable"}`))
	}

	return func(c *gin.Context) {
		// Preserve the original path
		c.Request.URL.Host = target.Host
		c.Request.URL.Scheme = target.Scheme
		c.Request.Host = target.Host

		// Forward request ID for tracing
		if reqID := c.GetHeader("X-Request-ID"); reqID == "" {
			c.Request.Header.Set("X-Request-ID", generateRequestID())
		}

		proxy.ServeHTTP(c.Writer, c.Request)
		c.Abort() // Prevent further Gin processing
	}
}

// WebSocketProxy creates a proxy handler that supports WebSocket upgrades
func WebSocketProxy(targetURL string) gin.HandlerFunc {
	target, err := url.Parse(targetURL)
	if err != nil {
		log.Fatalf("❌ Invalid WebSocket URL: %s - %v", targetURL, err)
	}

	return func(c *gin.Context) {
		// Check if this is a WebSocket upgrade request
		if strings.EqualFold(c.GetHeader("Upgrade"), "websocket") {
			proxy := httputil.NewSingleHostReverseProxy(target)
			proxy.ModifyResponse = nil

			c.Request.URL.Host = target.Host
			c.Request.URL.Scheme = target.Scheme
			c.Request.Host = target.Host

			proxy.ServeHTTP(c.Writer, c.Request)
			c.Abort()
			return
		}

		// Fall back to regular proxy
		ServiceProxy(targetURL)(c)
	}
}

// generateRequestID creates a simple request ID
func generateRequestID() string {
	return "gw-" + randomString(12)
}

func randomString(n int) string {
	const letters = "abcdefghijklmnopqrstuvwxyz0123456789"
	b := make([]byte, n)
	for i := range b {
		b[i] = letters[i%len(letters)]
	}
	return string(b)
}
