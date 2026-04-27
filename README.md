# <div style="display:flex;align-items:center;gap:12px">
# <img src="./docs/assets/silcon.svg" alt="RentRide" width="48" height="48" /> RentRide
</div>

RentRide is a modern, professionally maintained ride-hailing and vehicle rental platform — a microservices-based system built with Go, PostgreSQL, Flutter and React. This README focuses on clear setup, local development, and demo workflows for contributors and evaluators.

## ✨ Highlights

- 🧩 **Microservices architecture** with independently deployable services
- 🚪 **API Gateway** with routing, rate limiting, and JWT protection
- 🔐 **Authentication** with access and refresh tokens
- 👥 **Role-based access** for rider, driver, and admin workflows
- 📍 **Real-time tracking** powered by WebSockets
- 💸 **Cash payment flow** with driver collect / user confirm support
- 🔔 **Notifications** for ride lifecycle events
- 🗃️ **PostgreSQL + GORM** for structured persistence
- 🧰 **Shared core packages** for auth, logging, middleware, and API helpers
- 📘 **OpenAPI documentation** for service contracts
- ⚙️ **Frontend demo mode** support for running apps without the backend

## 📦 Applications

### 🌐 Admin Panel
- React + Vite admin dashboard
- Manage users, vehicles, rides, and payments

### 📱 User App
- Flutter app for riders
- Booking, tracking, notifications, profile, and payments

### 🚘 Driver App
- Flutter app for drivers
- Ride handling, status updates, navigation, and earnings views

## 🏗️ Architecture

```text
┌──────────────────────────────┐
│         API Gateway          │
│            :8000             │
│   Routing • Rate Limit • JWT │
└──────────────┬───────────────┘
               │
   ┌───────────┼───────────┬───────────┬───────────┬───────────┐
   │           │           │           │           │           │
┌──▼───┐   ┌───▼────┐  ┌───▼─────┐ ┌───▼─────┐ ┌───▼─────┐ ┌───▼────────┐
│Auth  │   │User   │  │Booking │ │Location │ │Vehicle │ │Payment/Notif│
│:8081 │   │:8080  │  │:8082   │ │:8083    │ │:8084   │ │:8085 / :8086│
└──────┘   └────────┘  └────────┘ └─────────┘ └────────┘ └────────────┘
```

## 🛠️ Tech Stack

### Backend
- 🟢 Go 1.26
- 🏎️ Gin Web Framework
- 🗃️ GORM + PostgreSQL
- 🔑 JWT authentication
- 🌐 `gorilla/websocket` for live location updates
- 📝 `logrus` for structured logging

### Frontend
- 🎨 React + Vite admin panel
- 📱 Flutter apps for user and driver
- 🧱 Shared Dart package for common client logic

## 🔌 Service Ports

| Service | Port | Purpose |
|---|---:|---|
| API Gateway | 8000 | Unified backend entry point |
| User Service | 8080 | Profiles and user data |
| Auth Service | 8081 | Login, register, refresh token |
| Booking Service | 8082 | Ride creation and lifecycle |
| Location Service | 8083 | GPS tracking and WebSocket stream |
| Vehicle Service | 8084 | Vehicle management |
| Payment Service | 8085 | Cash payment handling |
| Notification Service | 8086 | In-app notifications |

## 🚀 Quick Start

### ✅ Prerequisites
- Go 1.26+
- PostgreSQL 15+
- Node.js 18+ for the admin panel
- Flutter stable for the mobile/web apps

### 1) Configure environment

Copy the `.env.example` file for each backend service you want to run.

```bash
cd backend/auth-service
copy .env.example .env
```

### 2) Create databases

```sql
CREATE DATABASE rentride_users;
CREATE DATABASE rentride_bookings;
CREATE DATABASE rentride_locations;
CREATE DATABASE rentride_vehicles;
CREATE DATABASE rentride_payments;
CREATE DATABASE rentride_notifications;
CREATE DATABASE rentride_guides;
```

### 3) Run a backend service

```bash
cd backend/auth-service
go mod tidy
go run ./cmd
```

### 4) Run the API Gateway

```bash
cd backend/api-gateway
go run ./cmd
```

## 🧪 Frontend Demo Mode

For frontend-only demos, the shared Flutter core package can run in mock mode so the apps work without the backend.

- 🧑‍💻 **Admin Panel**: `http://localhost:3000/`
- 📱 **User App**: `http://localhost:8088/`
- 🚘 **Driver App**: `http://localhost:8089/`

## 🔌 API Overview

### 🔐 Auth Service
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/auth/register` | Register a new user |
| POST | `/api/v1/auth/login` | Login and receive tokens |
| POST | `/api/v1/auth/refresh` | Refresh access token |

### 🚗 Booking Service
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/rides` | Request a ride |
| PATCH | `/api/v1/rides/:id/status` | Update ride status |
| GET | `/api/v1/rides/:id` | Get ride details |
| GET | `/api/v1/rides/user/:user_id` | Get ride history |

### 🚘 Vehicle Service
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/vehicles` | Register a vehicle |
| PATCH | `/api/v1/vehicles/:id` | Update vehicle details |
| GET | `/api/v1/vehicles/driver/:driver_id` | Get driver vehicles |
| GET | `/api/v1/vehicles/driver/:driver_id/active` | Get active vehicle |

### 📍 Location Service
| Method | Endpoint | Description |
|---|---|---|
| PUT | `/api/v1/locations/driver` | Update driver location |
| GET | `/api/v1/locations/nearby` | Find nearby drivers |
| WS | `/api/v1/ws/track/:ride_id` | Rider tracking stream |
| WS | `/api/v1/ws/driver` | Driver location stream |

### 💳 Payment Service
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/payments` | Create payment record |
| PATCH | `/api/v1/payments/:id/collect` | Driver collects cash |
| PATCH | `/api/v1/payments/:id/confirm` | User confirms payment |
| GET | `/api/v1/payments/ride/:ride_id` | Get payment by ride |
| GET | `/api/v1/payments/history` | Payment history |
| GET | `/api/v1/payments/earnings` | Driver earnings |

### 🔔 Notification Service
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/notifications` | Get notifications |
| GET | `/api/v1/notifications/unread-count` | Unread count |
| PATCH | `/api/v1/notifications/:id/read` | Mark as read |
| PATCH | `/api/v1/notifications/read-all` | Mark all as read |
| POST | `/api/v1/notifications/internal/send` | Internal send endpoint |

## 📡 WebSockets

### Rider tracking
Connect to `ws://localhost:8083/api/v1/ws/track/:ride_id` with a JWT auth header.

Example payload:

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

### Driver push
Connect to `ws://localhost:8083/api/v1/ws/driver` with a JWT auth header.

Example payload:

```json
{
  "ride_id": 42,
  "latitude": 6.9271,
  "longitude": 79.8612,
  "heading": 180.0
}
```

## 🧪 Testing

Run tests for a specific service:

```bash
cd backend/auth-service
go test ./... -v
```

Run tests across all backend services:

```bash
for service in auth-service booking-service location-service vehicle-service payment-service notification-service user-service api-gateway; do
  echo Testing $service...
  cd backend/$service
  go test ./... -v
  cd ../..
done
```

## 📘 Documentation

- OpenAPI spec: `backend/docs/openapi.yaml`
- Shared Flutter package: `packages/core`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Open a pull request

## 📄 License

This project is licensed under the MIT License. See `LICENSE` for details.

## 📞 Support

If you find an issue, please open a GitHub issue in the repository.