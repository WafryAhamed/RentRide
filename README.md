<p align="center">
  <img src="./docs/assets/silcon.svg" alt="RentRide Logo" width="70"/>
</p>

<h1 align="center">🚖 RentRide</h1>

<p align="center">
  Microservices-based ride-hailing and vehicle rental platform.
</p>

<p align="center">
  <a href="https://github.com/WafryAhamed/RentRide"><img src="https://img.shields.io/github/stars/WafryAhamed/RentRide?style=for-the-badge" alt="Stars"/></a>
  <a href="https://github.com/WafryAhamed/RentRide/network/members"><img src="https://img.shields.io/github/forks/WafryAhamed/RentRide?style=for-the-badge" alt="Forks"/></a>
  <a href="https://github.com/WafryAhamed/RentRide/issues"><img src="https://img.shields.io/github/issues/WafryAhamed/RentRide?style=for-the-badge" alt="Issues"/></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/go.png" alt="Go" width="28"/>
  <img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/postgresql.png" alt="PostgreSQL" width="28"/>
  <img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/react.png" alt="React" width="28"/>
  <img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/vite.png" alt="Vite" width="28"/>
  <img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/flutter.png" alt="Flutter" width="28"/>
  <img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/dart.png" alt="Dart" width="28"/>
</p>

---

## 🚀 Overview

This repository is a monorepo containing:

- Go backend microservices under `backend/`
- React + Vite admin panel under `apps/admin_panel`
- Flutter user and driver applications under `apps/user_app` and `apps/driver_app`
- Shared Flutter package under `packages/core`
- Backend API specification at `backend/docs/openapi.yaml`

## 📁 Repository Structure (verified)

```text
apps/
  admin_panel/
  user_app/
  driver_app/
backend/
  api-gateway/
  auth-service/
  user-service/
  booking-service/
  location-service/
  vehicle-service/
  payment-service/
  notification-service/
  travel-guide-service/
  core/
  docs/openapi.yaml
packages/
  core/
scripts/
  setup_db.go
```

## 🧩 Backend Services (default ports from source)

Default ports below are taken from each service `cmd/main.go` fallback when `PORT` is unset.

| Service | Default Port |
|---|---:|
| API Gateway | 8000 |
| User Service | 8080 |
| Auth Service | 8081 |
| Booking Service | 8082 |
| Location Service | 8083 |
| Vehicle Service | 8084 |
| Payment Service | 8085 |
| Notification Service | 8086 |
| Travel Guide Service | 8087 |

## 🛠️ Tech Stack (from project files)

### Backend
- Go workspace version: `1.26.2` (`backend/go.work`)
- Gin (`github.com/gin-gonic/gin`)
- GORM + PostgreSQL drivers (used by services in `backend/*/config/database.go`)
- JWT auth middleware (gateway + auth service)
- WebSocket support in location service (`backend/location-service/websocket`)

### Admin Panel (`apps/admin_panel/package.json`)
- React `^19.2.4`
- Vite `^8.0.4`
- Axios `^1.15.0`
- React Router DOM `^7.14.0`
- jwt-decode `^4.0.0`

### Flutter Apps (`apps/user_app/pubspec.yaml`, `apps/driver_app/pubspec.yaml`)
- Dart SDK constraint: `^3.10.0`
- Flutter
- Riverpod `^2.6.1`
- go_router `^14.8.1`
- flutter_map `^7.0.2`

## ▶️ Local Development

### 1) Backend

Each backend service has an `.env.example` file.

```bash
cd backend/<service-name>
copy .env.example .env
go mod tidy
go run ./cmd
```

Start `api-gateway` after starting required downstream services.

### 2) Admin Panel

```bash
cd apps/admin_panel
npm install
npm run dev
```

### 3) Flutter Apps

```bash
cd apps/user_app
flutter pub get
flutter run
```

```bash
cd apps/driver_app
flutter pub get
flutter run
```

## 🔐 Admin Login (verified behavior)

In local/dev mode, `apps/admin_panel/src/contexts/AuthContext.jsx` supports mock admin login when:

- `localStorage.MOCK_ADMIN === "true"`, **or**
- `VITE_MOCK_AUTH === "true"`

This allows entering the admin UI without depending on full backend availability.

## 📘 API Documentation

- OpenAPI file: `backend/docs/openapi.yaml`

## 📸 Demo / Screenshots

The repo currently includes only this logo asset in `docs/assets/`:

- `docs/assets/silcon.svg`

If you want screenshot gallery images in README, add files under `docs/assets/screenshots/` and reference them here.

## 🧪 Testing

Run tests per backend service:

```bash
cd backend/<service-name>
go test ./... -v
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Open a pull request

## 📞 Support

If you find an issue, open a GitHub issue in this repository.
