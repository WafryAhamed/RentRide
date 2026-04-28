<p align="center">
  <img src="./docs/assets/silcon.svg" alt="RentRide Logo" width="70"/>
</p>

<h1 align="center">🚖 RentRide</h1>

<p align="center">
  Microservices-based ride-hailing and vehicle rental platform.
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
<img width="1672" height="941" alt="ChatGPT Image Apr 28, 2026, 05_35_52 AM" src="https://github.com/user-attachments/assets/7bd70817-735f-4d4c-842f-198d8817e710" />

## 🚀 Overview

This repository is a monorepo containing:

- Go backend microservices under `backend/`
- React + Vite admin panel under `apps/admin_panel`
- Flutter user and driver applications under `apps/user_app` and `apps/driver_app`
- Shared Flutter package under `packages/core`
- Backend API specification at `backend/docs/openapi.yaml`


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

<img width="1672" height="941" alt="89d1f912-a5c7-4342-8030-48ed15bb0b59" src="https://github.com/user-attachments/assets/e923175e-c133-4f45-8559-c91f0b6e984f" />

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

<table align="center">
  <tr>
    <td><img src="https://github.com/user-attachments/assets/f782773f-6674-4710-9652-1c6c3c31a89f" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/246322ab-9259-4104-8302-e5951c14ac0a" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/17d44b34-64a3-488f-937e-c1705f5b4875" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/7e755e2a-eeff-4c38-a32b-4bc045bfd88a" width="200"/></td>
  </tr>

  <tr>
    <td><img src="https://github.com/user-attachments/assets/55e6aeb5-6fe7-4001-8bc6-ce2c1bae9dee" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/895c006c-706b-4069-96cd-c3d69562e7ad" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/03dc76cb-627b-4bdb-8267-9664b759a64a" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/7f1b95f0-27f1-4de5-a259-24f928b39d08" width="200"/></td>
  </tr>

  <tr>
    <td><img src="https://github.com/user-attachments/assets/84a5ebb0-5505-42bc-8003-0c5d9341fffd" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/a676eff4-1c3d-4953-96ba-095f23a64eac" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/eb858d75-da2e-4d39-bed8-db619f1801ea" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/af6a294a-6c58-46ec-9cb2-ee3f2e7bffc7" width="200"/></td>
  </tr>
</table>


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
