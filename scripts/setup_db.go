package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"
	"golang.org/x/crypto/bcrypt"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "postgres"
	password = "2001"
)

var databases = []string{
	"rentride_users",
	"rentride_bookings",
	"rentride_locations",
	"rentride_vehicles",
	"rentride_payments",
	"rentride_notifications",
	"rentride_guides",
}

func main() {
	// Connect to default postgres database
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=postgres sslmode=disable", host, port, user, password)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("❌ Failed to connect to PostgreSQL: %v", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("❌ Failed to ping PostgreSQL: %v", err)
	}
	log.Println("✅ Connected to PostgreSQL")

	// Create databases
	for _, dbName := range databases {
		var exists bool
		err := db.QueryRow("SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = $1)", dbName).Scan(&exists)
		if err != nil {
			log.Fatalf("❌ Error checking database %s: %v", dbName, err)
		}
		if exists {
			log.Printf("⏭️  Database '%s' already exists", dbName)
		} else {
			_, err := db.Exec(fmt.Sprintf("CREATE DATABASE %s", dbName))
			if err != nil {
				log.Fatalf("❌ Failed to create database '%s': %v", dbName, err)
			}
			log.Printf("✅ Created database '%s'", dbName)
		}
	}

	// Seed admin user into rentride_users
	seedAdmin()

	log.Println("\n🎉 Database setup complete!")
}

func seedAdmin() {
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=rentride_users sslmode=disable", host, port, user, password)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("❌ Failed to connect to rentride_users: %v", err)
	}
	defer db.Close()

	// Ensure users table exists
	_, err = db.Exec(`
		CREATE TABLE IF NOT EXISTS users (
			id SERIAL PRIMARY KEY,
			full_name VARCHAR(100) NOT NULL,
			email VARCHAR(100) UNIQUE NOT NULL,
			phone VARCHAR(20) UNIQUE NOT NULL,
			password VARCHAR(255) NOT NULL,
			role VARCHAR(20) DEFAULT 'rider',
			avatar_url VARCHAR(500),
			is_active BOOLEAN DEFAULT true,
			created_at TIMESTAMPTZ DEFAULT NOW(),
			updated_at TIMESTAMPTZ DEFAULT NOW(),
			deleted_at TIMESTAMPTZ
		)
	`)
	if err != nil {
		log.Fatalf("❌ Failed to create users table: %v", err)
	}

	// Ensure refresh_tokens table exists
	_, err = db.Exec(`
		CREATE TABLE IF NOT EXISTS refresh_tokens (
			id SERIAL PRIMARY KEY,
			user_id INTEGER NOT NULL,
			token VARCHAR(500) UNIQUE NOT NULL,
			expires_at TIMESTAMPTZ NOT NULL,
			created_at TIMESTAMPTZ DEFAULT NOW()
		)
	`)
	if err != nil {
		log.Fatalf("❌ Failed to create refresh_tokens table: %v", err)
	}

	// Check if admin exists
	var exists bool
	err = db.QueryRow("SELECT EXISTS(SELECT 1 FROM users WHERE email = 'admin@rentride.com')").Scan(&exists)
	if err != nil {
		log.Fatalf("❌ Error checking admin user: %v", err)
	}

	if exists {
		log.Println("⏭️  Admin user already exists")
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte("admin123"), 14)
	if err != nil {
		log.Fatalf("❌ Failed to hash password: %v", err)
	}

	_, err = db.Exec(
		"INSERT INTO users (full_name, email, phone, password, role, is_active) VALUES ($1, $2, $3, $4, $5, $6)",
		"System Admin", "admin@rentride.com", "+94770000000", string(hashedPassword), "ADMIN", true,
	)
	if err != nil {
		log.Fatalf("❌ Failed to seed admin: %v", err)
	}
	log.Println("✅ Seeded admin user: admin@rentride.com / admin123")
}
