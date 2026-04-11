package services

import (
	"testing"

	"rentride/vehicle-service/models"
)

// TestRegisterVehicleRequest_Validation tests vehicle registration request
func TestRegisterVehicleRequest_Validation(t *testing.T) {
	req := models.RegisterVehicleRequest{
		Make:         "Toyota",
		Model:        "Corolla",
		Year:         2022,
		LicensePlate: "ABC-1234",
		Category:     models.CategorySedan,
		Color:        "White",
	}

	if req.Make == "" {
		t.Error("Make should not be empty")
	}
	if req.Model == "" {
		t.Error("Model should not be empty")
	}
	if req.Year < 2000 || req.Year > 2030 {
		t.Error("Year should be between 2000 and 2030")
	}
	if req.LicensePlate == "" {
		t.Error("LicensePlate should not be empty")
	}
}

// TestVehicleCategory_Constants tests category constants
func TestVehicleCategory_Constants(t *testing.T) {
	tests := []struct {
		name     string
		category models.VehicleCategory
		want     string
	}{
		{"Hatchback", models.CategoryHatchback, "HATCHBACK"},
		{"Sedan", models.CategorySedan, "SEDAN"},
		{"SUV", models.CategorySUV, "SUV"},
		{"Van", models.CategoryVan, "VAN"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if string(tt.category) != tt.want {
				t.Errorf("Expected %s, got %s", tt.want, string(tt.category))
			}
		})
	}
}

// TestVehicleTableName tests the table name
func TestVehicleTableName(t *testing.T) {
	v := models.Vehicle{}
	if v.TableName() != "vehicles" {
		t.Errorf("Expected table name 'vehicles', got '%s'", v.TableName())
	}
}

// TestUpdateVehicleRequest tests optional fields
func TestUpdateVehicleRequest(t *testing.T) {
	make := "Honda"
	year := 2023
	isActive := true

	req := models.UpdateVehicleRequest{
		Make:     &make,
		Year:     &year,
		IsActive: &isActive,
	}

	if req.Make == nil || *req.Make != "Honda" {
		t.Error("Make should be 'Honda'")
	}
	if req.Model != nil {
		t.Error("Model should be nil (not updated)")
	}
	if req.Year == nil || *req.Year != 2023 {
		t.Error("Year should be 2023")
	}
}
