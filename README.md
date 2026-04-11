# RentRide - Microservices Architecture

RentRide is a modern vehicle rental platform built with a microservices architecture using Go and PostgreSQL.

## 🚀 Features

- **Microservices Architecture**: 8 decoupled services for scalability
- **API Gateway**: Single entry point with rate limiting and JWT validation
- **JWT Authentication**: Secure user authentication with access and refresh tokens
- **Role-Based Access**: Support for different user roles (rider, driver, admin)
- **Real-Time Tracking**: WebSocket-based live location tracking
- **Cash Payments**: Cash-only payment processing with driver collect / user confirm flow
- **In-App Notifications**: Notification system for ride lifecycle events
- **PostgreSQL Database**: Reliable data storage with GORM ORM
- **Gin Framework**: High-performance web framework for Go
- **Shared Core Package**: Common middleware, logging, errors, and HTTP client
- **API Documentation**: Full OpenAPI 3.0 specification
- **CI/CD Pipeline**: GitHub Actions for lint, test, and deploy

## 📂 Project Structure

```
RentRide/
├── .github/workflows/          # CI/CD pipeline
│   ├── ci.yml                  # Lint → Test → Build
│   └── deploy.yml              # Build & Deploy
├── backend/
│   ├── api-gateway/            # Single entry point (:8000)
│   ├── auth-service/           # Authentication & JWT (:8081)
│   ├── user-service/           # User profiles (:8080)
│   ├── booking-service/        # Ride bookings (:8082)
│   ├── location-service/       # GPS tracking + WebSocket (:8083)
│   ├── vehicle-service/        # Vehicle management (:8084)
│   ├── payment-service/        # Cash payments (:8085)
│   ├── notification-service/   # In-app notifications (:8086)
│   ├── core/                   # Shared libraries
│   │   ├── errors/             # Standard error types
│   │   ├── httpclient/         # Inter-service HTTP client
│   │   ├── logger/             # Structured logging (logrus)
│   │   ├── middleware/         # Shared auth, CORS, logging, recovery
│   │   └── response/           # Unified API response format
│   └── docs/                   # API documentation
│       └── openapi.yaml        # OpenAPI 3.0 specification
├── apps/
│   ├── user_app/               # Flutter rider application
│   └── driver_app/             # Flutter driver application
└── packages/                   # Shared Flutter packages
```

## 🛠️ Tech Stack

### Backend
- **Go 1.26** with **Gin Framework**
- **GORM** (PostgreSQL ORM)
- **JWT** (JSON Web Tokens) with access + refresh token rotation
- **gorilla/websocket** for real-time tracking
- **logrus** for structured logging
- **PostgreSQL** (separate DB per service)

### Frontend
- **Flutter** (Dart)
- User app + Driver app

## 🔌 Service Port Map

| Service | Port | Description |
|---------|------|-------------|
| API Gateway | 8000 | Single entry point, rate limiting, auth |
| User Service | 8080 | User profiles and preferences |
| Auth Service | 8081 | Registration, login, token refresh |
| Booking Service | 8082 | Ride creation and lifecycle |
| Location Service | 8083 | GPS tracking + WebSocket |
| Vehicle Service | 8084 | Vehicle registration and management |
| Payment Service | 8085 | Cash payment processing |
| Notification Service | 8086 | In-app notifications |

## 🚀 Getting Started

### Prerequisites
- Go 1.26+
- PostgreSQL 15+

### 1. Setup Environment

Each service has a `.env.example` file. Copy and configure:

```bash
cd backend/auth-service
cp .env.example .env
# Edit .env with your database credentials
```

### 2. Create Databases

```sql
CREATE DATABASE rentride_users;
CREATE DATABASE rentride_bookings;
CREATE DATABASE rentride_locations;
CREATE DATABASE rentride_vehicles;
CREATE DATABASE rentride_payments;
CREATE DATABASE rentride_notifications;
```

### 3. Run a Service

```bash
cd backend/auth-service
go mod tidy
go run cmd/main.go
```

### 4. Run via API Gateway

Start all services, then start the gateway:

```bash
cd backend/api-gateway
go run cmd/main.go
# All services accessible via http://localhost:8000/api/v1/
```

## 🔌 API Endpoints

### Auth Service
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register new user |
| POST | `/api/v1/auth/login` | Login user |
| POST | `/api/v1/auth/refresh` | Refresh access token |

### Booking Service
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/rides` | Request a ride |
| PATCH | `/api/v1/rides/:id/status` | Update ride status |
| GET | `/api/v1/rides/:id` | Get ride details |
| GET | `/api/v1/rides/user/:user_id` | Get ride history |

### Vehicle Service
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/vehicles` | Register vehicle |
| PATCH | `/api/v1/vehicles/:id` | Update vehicle |
| GET | `/api/v1/vehicles/driver/:driver_id` | Get driver vehicles |
| GET | `/api/v1/vehicles/driver/:driver_id/active` | Get active vehicle |

### Location Service
| Method | Endpoint | Description |
|--------|----------|-------------|
| PUT | `/api/v1/locations/driver` | Update driver location |
| GET | `/api/v1/locations/nearby` | Find nearby drivers |
| WS | `/api/v1/ws/track/:ride_id` | Track ride (WebSocket) |
| WS | `/api/v1/ws/driver` | Driver location push (WebSocket) |

### Payment Service (Cash Only)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/payments` | Create payment record |
| PATCH | `/api/v1/payments/:id/collect` | Driver collects cash |
| PATCH | `/api/v1/payments/:id/confirm` | User confirms payment |
| GET | `/api/v1/payments/ride/:ride_id` | Get payment by ride |
| GET | `/api/v1/payments/history` | Payment history |
| GET | `/api/v1/payments/earnings` | Driver earnings |

### Notification Service
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/notifications` | Get notifications |
| GET | `/api/v1/notifications/unread-count` | Unread count |
| PATCH | `/api/v1/notifications/:id/read` | Mark as read |
| PATCH | `/api/v1/notifications/read-all` | Mark all as read |
| POST | `/api/v1/notifications/internal/send` | Send (internal) |

## 📡 WebSocket Protocol

### Rider Tracking
Connect to `ws://localhost:8083/api/v1/ws/track/:ride_id` with JWT auth header.
Receive messages:
```json
{
  "type": "LOCATION_UPDATE",
  "ride_id": 42,
  "driver_id": 7,
  "latitude": 6.9271,
  "longitude": 79.8612,
  "heading": 180.0
}
```

### Driver Push
Connect to `ws://localhost:8083/api/v1/ws/driver` with JWT auth header.
Send messages:
```json
{
  "ride_id": 42,
  "latitude": 6.9271,
  "longitude": 79.8612,
  "heading": 180.0
}
```

## 🧪 Testing

```bash
# Run tests for a specific service
cd backend/auth-service
go test ./... -v

# Run tests for all services
for service in auth-service booking-service location-service vehicle-service payment-service notification-service; do
  echo "Testing $service..."
  cd backend/$service && go test ./... -v && cd ../..
done
```

## 📄 API Documentation

Full OpenAPI 3.0 specification available at `backend/docs/openapi.yaml`.

## 🔒 Architecture

```
                    ┌──────────────────┐
                    │   API Gateway    │
                    │    :8000         │
                    │ (JWT + Rate Limit)│
                    └────────┬─────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
    ┌────▼────┐        ┌─────▼─────┐       ┌────▼────┐
    │  Auth   │        │  Booking  │       │Location │
    │ :8081   │        │  :8082    │       │ :8083   │
    └─────────┘        └───────────┘       │ (+ WS)  │
         │                   │              └─────────┘
    ┌────▼────┐        ┌─────▼─────┐       ┌─────────┐
    │  User   │        │ Payment   │       │Vehicle  │
    │ :8080   │        │  :8085    │       │ :8084   │
    └─────────┘        └───────────┘       └─────────┘
                             │
                       ┌─────▼──────┐
                       │Notification│
                       │  :8086     │
                       └────────────┘
```

## ⚙️ CI/CD

GitHub Actions pipelines:
- **CI** (`ci.yml`): Runs on push/PR → Lint → Test → Build
- **Deploy** (`deploy.yml`): Runs on main push → Test → Build → Docker

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For issues or questions, please open an issue in the repository.,