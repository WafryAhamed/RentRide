package middleware

import (
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

// RateLimiter implements a simple token bucket rate limiter per IP
type RateLimiter struct {
	visitors map[string]*visitor
	mu       sync.RWMutex
	rate     int           // requests per second
	burst    int           // burst capacity
	cleanup  time.Duration // how often to clean up stale entries
}

type visitor struct {
	tokens    float64
	lastSeen  time.Time
	lastCheck time.Time
}

// NewRateLimiter creates a rate limiter
func NewRateLimiter(rps int) *RateLimiter {
	rl := &RateLimiter{
		visitors: make(map[string]*visitor),
		rate:     rps,
		burst:    rps * 2,
		cleanup:  5 * time.Minute,
	}

	// Cleanup goroutine
	go func() {
		for {
			time.Sleep(rl.cleanup)
			rl.mu.Lock()
			for ip, v := range rl.visitors {
				if time.Since(v.lastSeen) > rl.cleanup {
					delete(rl.visitors, ip)
				}
			}
			rl.mu.Unlock()
		}
	}()

	return rl
}

// RateLimit returns a Gin middleware that rate limits requests per IP
func (rl *RateLimiter) RateLimit() gin.HandlerFunc {
	return func(c *gin.Context) {
		ip := c.ClientIP()

		rl.mu.Lock()
		v, exists := rl.visitors[ip]
		now := time.Now()

		if !exists {
			v = &visitor{
				tokens:    float64(rl.burst),
				lastSeen:  now,
				lastCheck: now,
			}
			rl.visitors[ip] = v
		}

		// Add tokens based on elapsed time
		elapsed := now.Sub(v.lastCheck).Seconds()
		v.tokens += elapsed * float64(rl.rate)
		if v.tokens > float64(rl.burst) {
			v.tokens = float64(rl.burst)
		}
		v.lastCheck = now
		v.lastSeen = now

		if v.tokens < 1 {
			rl.mu.Unlock()
			c.JSON(http.StatusTooManyRequests, gin.H{
				"success": false,
				"error":   "Rate limit exceeded. Please try again later.",
			})
			c.Abort()
			return
		}

		v.tokens--
		rl.mu.Unlock()

		c.Next()
	}
}
