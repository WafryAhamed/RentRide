# RentRide - Microservices Architecture

RentRide is a modern vehicle rental platform built with a microservices architecture using Go and PostgreSQL.

## 🚀 Features

- **Microservices Architecture**: Separated services for Authentication, Users, Vehicles, and Payments
- **JWT Authentication**: Secure user authentication with access and refresh tokens
- **Role-Based Access**: Support for different user roles (rider, owner, admin)
- **PostgreSQL Database**: Reliable data storage with GORM ORM
- **Gin Framework**: High-performance web framework for Go
- **Dockerized**: Easy deployment with Docker and Docker Compose

## 📂 Project Structure

```
RentRide/
├── backend/
│   ├── auth-service/       # Authentication and user management
│   ├── user-service/       # User profiles and preferences
│   ├── vehicle-service/    # Vehicle listings and availability
│   ├── payment-service/    # Payment processing and transactions
│   └── shared/             # Shared libraries and utilities
├── frontend/               # React frontend application
├── docker/                 # Docker configurations
└── docker-compose.yml      # Multi-container orchestration
```

## 🛠️ Tech Stack

### Backend
- **Go 1.26**
- **Gin Framework**
- **GORM (PostgreSQL ORM)**
- **JWT (JSON Web Tokens)**
- **PostgreSQL**

### Frontend
- **React**
- **Redux Toolkit**
- **Tailwind CSS**
- **Axios**

## 🚀 Getting Started

### Prerequisites
- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) installed
- Go 1.26+ (for local development)

### 1. Start with Docker Compose

The easiest way to run the entire application is using Docker Compose:

```bash
# Start all services (backend, frontend, database)
docker-compose up -d

# Stop all services
docker-compose down
```

### 2. Backend Development

To run a specific service locally:

```bash
# Navigate to the service directory
cd backend/auth-service

# Install dependencies
go mod tidy

# Run the service
go run cmd/main.go
```

### 3. Frontend Development

```bash
# Navigate to the frontend directory
cd frontend

# Install dependencies
npm install

# Start the development server
npm start
```

## 🔌 API Endpoints

### Auth Service
- `POST /api/v1/auth/register` - Register a new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token

### User Service
- `GET /api/v1/users/me` - Get current user profile
- `PUT /api/v1/users/me` - Update user profile

### Vehicle Service
- `GET /api/v1/vehicles` - List all vehicles
- `POST /api/v1/vehicles` - Create a new vehicle
- `GET /api/v1/vehicles/:id` - Get vehicle by ID
- `PUT /api/v1/vehicles/:id` - Update vehicle
- `DELETE /api/v1/vehicles/:id` - Delete vehicle

### Payment Service
- `POST /api/v1/payments/create-intent` - Create payment intent
- `POST /api/v1/payments/webhook` - Payment webhook
- `GET /api/v1/payments/history` - Payment history

## 🧪 Testing

### Run Backend Tests

```bash
# Navigate to service directory
cd backend/auth-service

# Run tests
go test ./...
```

## 📦 Deployment

### Docker Deployment

```bash
# Build and start services
docker-compose up -d --build

# Scale services
docker-compose up -d --scale auth-service=3 --scale user-service=2
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For issues or questions, please open an issue in the repository.