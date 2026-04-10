package repository

import (
	"time"

	"rentride/location-service/config"
	"rentride/location-service/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type LocationRepository struct {
	db *gorm.DB
}

func NewLocationRepository() *LocationRepository {
	return &LocationRepository{db: config.DB}
}

// UpsertLocation saves a new tracking ping, overwriting the previous one
func (r *LocationRepository) UpsertLocation(loc *models.DriverLocation) error {
	// clause.OnConflict triggers UPSERT (INSERT ON CONFLICT DO UPDATE)
	return r.db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "driver_id"}},
		DoUpdates: clause.AssignmentColumns([]string{"latitude", "longitude", "heading", "is_online", "updated_at"}),
	}).Create(loc).Error
}

// FindNearbyDrivers uses the Haversine formula to find online drivers within a radius
// Will filter out drivers who haven't pinged in the last 15 minutes (stale data).
func (r *LocationRepository) FindNearbyDrivers(lat float64, lng float64, radiusKm float64) ([]models.DriverLocation, error) {
	var locations []models.DriverLocation
	activeThreshold := time.Now().Add(-15 * time.Minute)

	// Haversine formula directly in PostgreSQL. Radius of Earth is ~6371km.
	query := `
		SELECT * FROM driver_locations
		WHERE is_online = true
		  AND updated_at >= ?
		  AND (
		      6371 * acos(
		          cos(radians(?)) * cos(radians(latitude)) * 
		          cos(radians(longitude) - radians(?)) + 
		          sin(radians(?)) * sin(radians(latitude))
		      )
		  ) <= ?
		ORDER BY (
		      6371 * acos(
		          cos(radians(?)) * cos(radians(latitude)) * 
		          cos(radians(longitude) - radians(?)) + 
		          sin(radians(?)) * sin(radians(latitude))
		      )
		) ASC
		LIMIT 20
	`

	// Note exact ordering of arguments:
	// updated_at, lat, lng, lat, radiusKm, lat, lng, lat
	err := r.db.Raw(query, activeThreshold, lat, lng, lat, radiusKm, lat, lng, lat).Scan(&locations).Error
	
	return locations, err
}
