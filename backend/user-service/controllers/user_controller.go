package controllers

import (
	"net/http"
	"strconv"

	"rentride/user-service/models"
	"rentride/user-service/services"

	"github.com/gin-gonic/gin"
)

// UserController handles HTTP requests for user operations.
type UserController struct {
	service *services.UserService
}

// NewUserController creates a new UserController instance.
func NewUserController() *UserController {
	return &UserController{
		service: services.NewUserService(),
	}
}

// CreateUser godoc
// @Summary      Create a new user
// @Description  Register a new rider or driver on the platform
// @Tags         users
// @Accept       json
// @Produce      json
// @Param        user  body      models.CreateUserRequest  true  "User data"
// @Success      201   {object}  models.UserResponse
// @Failure      400   {object}  map[string]interface{}
// @Router       /api/v1/users [post]
func (ctrl *UserController) CreateUser(c *gin.Context) {
	var req models.CreateUserRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Invalid request body: " + err.Error(),
		})
		return
	}

	user, err := ctrl.service.CreateUser(req)
	if err != nil {
		c.JSON(http.StatusConflict, gin.H{
			"success": false,
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"success": true,
		"message": "User created successfully",
		"data":    user,
	})
}

// GetAllUsers godoc
// @Summary      List all users
// @Description  Get paginated list of all users
// @Tags         users
// @Produce      json
// @Param        page   query     int  false  "Page number"  default(1)
// @Param        limit  query     int  false  "Items per page"  default(10)
// @Success      200    {object}  map[string]interface{}
// @Router       /api/v1/users [get]
func (ctrl *UserController) GetAllUsers(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "10"))

	users, total, err := ctrl.service.GetAllUsers(page, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Failed to retrieve users",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data":    users,
		"meta": gin.H{
			"total":        total,
			"page":         page,
			"limit":        limit,
			"total_pages":  (total + int64(limit) - 1) / int64(limit),
		},
	})
}

// GetUserByID godoc
// @Summary      Get user by ID
// @Description  Get a single user's details
// @Tags         users
// @Produce      json
// @Param        id   path      int  true  "User ID"
// @Success      200  {object}  models.UserResponse
// @Failure      404  {object}  map[string]interface{}
// @Router       /api/v1/users/{id} [get]
func (ctrl *UserController) GetUserByID(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Invalid user ID",
		})
		return
	}

	user, err := ctrl.service.GetUserByID(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data":    user,
	})
}

// UpdateUser godoc
// @Summary      Update a user
// @Description  Update user profile fields
// @Tags         users
// @Accept       json
// @Produce      json
// @Param        id    path      int                      true  "User ID"
// @Param        user  body      models.UpdateUserRequest  true  "Fields to update"
// @Success      200   {object}  models.UserResponse
// @Failure      404   {object}  map[string]interface{}
// @Router       /api/v1/users/{id} [put]
func (ctrl *UserController) UpdateUser(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Invalid user ID",
		})
		return
	}

	var req models.UpdateUserRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Invalid request body: " + err.Error(),
		})
		return
	}

	user, err := ctrl.service.UpdateUser(uint(id), req)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "User updated successfully",
		"data":    user,
	})
}

// DeleteUser godoc
// @Summary      Delete a user
// @Description  Soft delete a user by ID
// @Tags         users
// @Produce      json
// @Param        id   path      int  true  "User ID"
// @Success      200  {object}  map[string]interface{}
// @Failure      404  {object}  map[string]interface{}
// @Router       /api/v1/users/{id} [delete]
func (ctrl *UserController) DeleteUser(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Invalid user ID",
		})
		return
	}

	if err := ctrl.service.DeleteUser(uint(id)); err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "User deleted successfully",
	})
}

// GetProfile returns the user profile of the currently authenticated user
func (ctrl *UserController) GetProfile(c *gin.Context) {
	// user_id is injected by the AuthRequired middleware from JWT claims
	userIDVal, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "User ID not found in token",
		})
		return
	}

	// JWT claims store numbers as float64
	var userID uint
	switch v := userIDVal.(type) {
	case float64:
		userID = uint(v)
	case uint:
		userID = v
	default:
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "Invalid user ID format in token",
		})
		return
	}

	user, err := ctrl.service.GetUserByID(userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data":    user,
	})
}
