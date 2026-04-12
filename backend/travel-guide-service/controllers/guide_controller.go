package controllers

import (
	"net/http"
	"strconv"

	"rentride/core/response"
	"rentride/travel-guide-service/services"

	"github.com/gin-gonic/gin"
)

type GuideController struct {
	service *services.GuideService
}

func NewGuideController(service *services.GuideService) *GuideController {
	return &GuideController{service: service}
}

func (c *GuideController) GetPlaces(ctx *gin.Context) {
	city := ctx.Query("city")
	category := ctx.Query("category")
	
	page, _ := strconv.Atoi(ctx.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(ctx.DefaultQuery("limit", "20"))
	offset := (page - 1) * limit

	places, err := c.service.GetPlaces(city, category, limit, offset)
	if err != nil {
		response.Error(ctx, http.StatusInternalServerError, "Failed to retrieve places")
		return
	}
	response.Success(ctx, http.StatusOK, "data retrieved", places)
}

func (c *GuideController) GetPlaceByID(ctx *gin.Context) {
	idParam := ctx.Param("id")
	id, err := strconv.ParseUint(idParam, 10, 32)
	if err != nil {
		response.Error(ctx, http.StatusBadRequest, "Invalid ID format")
		return
	}

	place, err := c.service.GetPlaceByID(uint(id))
	if err != nil {
		response.Error(ctx, http.StatusNotFound, "Place not found")
		return
	}
	response.Success(ctx, http.StatusOK, "data retrieved", place)
}

func (c *GuideController) GetCategories(ctx *gin.Context) {
	cats, err := c.service.GetCategories()
	if err != nil {
		response.Error(ctx, http.StatusInternalServerError, "Failed to retrieve categories")
		return
	}
	response.Success(ctx, http.StatusOK, "data retrieved", cats)
}

func (c *GuideController) GetFeatured(ctx *gin.Context) {
	featured, err := c.service.GetFeaturedPlaces()
	if err != nil {
		response.Error(ctx, http.StatusInternalServerError, "Failed to retrieve featured places")
		return
	}
	response.Success(ctx, http.StatusOK, "data retrieved", featured)
}
