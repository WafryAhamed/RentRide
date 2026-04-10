package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func TestEndpoint(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "User Service API is running securely! Connection to PostgreSQL successful.",
	})
}
