package services

import (
	"rentride/travel-guide-service/models"
	"rentride/travel-guide-service/repository"
)

type GuideService struct {
	repo *repository.PlaceRepository
}

func NewGuideService(repo *repository.PlaceRepository) *GuideService {
	return &GuideService{repo: repo}
}

func (s *GuideService) GetPlaces(city string, category string, limit int, offset int) ([]models.Place, error) {
	if limit == 0 {
		limit = 20
	}
	return s.repo.GetAll(city, category, limit, offset)
}

func (s *GuideService) GetPlaceByID(id uint) (*models.Place, error) {
	return s.repo.GetByID(id)
}

func (s *GuideService) GetCategories() ([]string, error) {
	return s.repo.GetCategories()
}

func (s *GuideService) GetFeaturedPlaces() ([]models.Place, error) {
	return s.repo.GetFeatured()
}

func (s *GuideService) CreatePlace(place *models.Place) error {
    return s.repo.Create(place)
}
