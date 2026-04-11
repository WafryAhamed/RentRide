package websocket

import (
	"log"
	"sync"
)

// Hub manages all active WebSocket connections for real-time tracking
type Hub struct {
	// Map of rideID → list of clients tracking that ride (riders)
	rideClients map[uint][]*Client

	// Map of driverID → client (driver pushing locations)
	driverClients map[uint]*Client

	// Register requests from clients
	Register chan *Client

	// Unregister requests from clients
	Unregister chan *Client

	// Broadcast location updates to ride subscribers
	Broadcast chan *LocationMessage

	mu sync.RWMutex
}

// LocationMessage represents a real-time location update
type LocationMessage struct {
	Type      string  `json:"type"`       // LOCATION_UPDATE, DRIVER_ARRIVED, RIDE_STARTED
	RideID    uint    `json:"ride_id"`
	DriverID  uint    `json:"driver_id"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	Heading   float64 `json:"heading"`
}

// NewHub creates a new WebSocket hub
func NewHub() *Hub {
	return &Hub{
		rideClients:   make(map[uint][]*Client),
		driverClients: make(map[uint]*Client),
		Register:      make(chan *Client),
		Unregister:    make(chan *Client),
		Broadcast:     make(chan *LocationMessage),
	}
}

// Run starts the hub's main event loop
func (h *Hub) Run() {
	for {
		select {
		case client := <-h.Register:
			h.mu.Lock()
			if client.IsDriver {
				h.driverClients[client.UserID] = client
				log.Printf("🔌 Driver %d connected via WebSocket", client.UserID)
			} else {
				h.rideClients[client.RideID] = append(h.rideClients[client.RideID], client)
				log.Printf("🔌 Rider connected to track ride %d", client.RideID)
			}
			h.mu.Unlock()

		case client := <-h.Unregister:
			h.mu.Lock()
			if client.IsDriver {
				delete(h.driverClients, client.UserID)
				log.Printf("🔌 Driver %d disconnected", client.UserID)
			} else {
				clients := h.rideClients[client.RideID]
				for i, c := range clients {
					if c == client {
						h.rideClients[client.RideID] = append(clients[:i], clients[i+1:]...)
						break
					}
				}
				if len(h.rideClients[client.RideID]) == 0 {
					delete(h.rideClients, client.RideID)
				}
				log.Printf("🔌 Rider disconnected from ride %d", client.RideID)
			}
			close(client.Send)
			h.mu.Unlock()

		case message := <-h.Broadcast:
			h.mu.RLock()
			// Send to all clients tracking this ride
			clients := h.rideClients[message.RideID]
			for _, client := range clients {
				select {
				case client.Send <- message:
				default:
					// Client buffer full, skip
				}
			}
			h.mu.RUnlock()
		}
	}
}

// BroadcastToRide sends a message to all clients tracking a specific ride
func (h *Hub) BroadcastToRide(msg *LocationMessage) {
	h.Broadcast <- msg
}

// GetOnlineDriverCount returns the number of connected drivers
func (h *Hub) GetOnlineDriverCount() int {
	h.mu.RLock()
	defer h.mu.RUnlock()
	return len(h.driverClients)
}
