package repository

import (
	"rentride/travel-guide-service/models"

	"gorm.io/gorm"
)

type PlaceRepository struct {
	db *gorm.DB
}

func NewPlaceRepository(db *gorm.DB) *PlaceRepository {
	return &PlaceRepository{db: db}
}

func (r *PlaceRepository) GetAll(city string, category string, limit int, offset int) ([]models.Place, error) {
	var places []models.Place
	query := r.db.Model(&models.Place{})

	if city != "" {
		query = query.Where("city = ?", city)
	}
	if category != "" {
		query = query.Where("category = ?", category)
	}

	err := query.Limit(limit).Offset(offset).Find(&places).Error
	return places, err
}

func (r *PlaceRepository) GetByID(id uint) (*models.Place, error) {
	var place models.Place
	err := r.db.First(&place, id).Error
	if err != nil {
		return nil, err
	}
	return &place, nil
}

func (r *PlaceRepository) GetCategories() ([]string, error) {
	var categories []string
	err := r.db.Model(&models.Place{}).Distinct("category").Pluck("category", &categories).Error
	return categories, err
}

func (r *PlaceRepository) GetFeatured() ([]models.Place, error) {
	var places []models.Place
	// Arbitrary definition of featured: Highest rating, limit 5
	err := r.db.Order("rating desc").Limit(5).Find(&places).Error
	return places, err
}

func (r *PlaceRepository) Create(place *models.Place) error {
	return r.db.Create(place).Error
}
// more methods like Update/Delete can be added for admin panel later
