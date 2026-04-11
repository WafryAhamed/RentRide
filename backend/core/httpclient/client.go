package httpclient

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"rentride/core/logger"
)

// Client is a typed HTTP client for inter-service communication
type Client struct {
	httpClient *http.Client
	baseURL    string
	service    string
}

// NewClient creates a new inter-service HTTP client
func NewClient(serviceName string) *Client {
	baseURL, exists := Services[serviceName]
	if !exists {
		logger.Log.Fatalf("Unknown service: %s", serviceName)
	}

	return &Client{
		httpClient: &http.Client{
			Timeout: 10 * time.Second,
		},
		baseURL: baseURL,
		service: serviceName,
	}
}

// Get performs a GET request to the target service
func (c *Client) Get(path string, headers map[string]string) ([]byte, int, error) {
	return c.do("GET", path, nil, headers)
}

// Post performs a POST request to the target service
func (c *Client) Post(path string, body interface{}, headers map[string]string) ([]byte, int, error) {
	return c.do("POST", path, body, headers)
}

// Patch performs a PATCH request to the target service
func (c *Client) Patch(path string, body interface{}, headers map[string]string) ([]byte, int, error) {
	return c.do("PATCH", path, body, headers)
}

// do executes the HTTP request with retry logic
func (c *Client) do(method, path string, body interface{}, headers map[string]string) ([]byte, int, error) {
	url := c.baseURL + path
	maxRetries := 3

	var lastErr error
	for attempt := 0; attempt < maxRetries; attempt++ {
		if attempt > 0 {
			// Exponential backoff: 100ms, 200ms, 400ms
			time.Sleep(time.Duration(100*(1<<attempt)) * time.Millisecond)
		}

		var reqBody io.Reader
		if body != nil {
			jsonBytes, err := json.Marshal(body)
			if err != nil {
				return nil, 0, fmt.Errorf("failed to marshal request body: %w", err)
			}
			reqBody = bytes.NewBuffer(jsonBytes)
		}

		req, err := http.NewRequest(method, url, reqBody)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to create request: %w", err)
		}

		req.Header.Set("Content-Type", "application/json")
		for k, v := range headers {
			req.Header.Set(k, v)
		}

		resp, err := c.httpClient.Do(req)
		if err != nil {
			lastErr = err
			logger.Log.WithField("service", c.service).
				WithField("attempt", attempt+1).
				Warnf("Request failed: %v", err)
			continue
		}
		defer resp.Body.Close()

		respBody, err := io.ReadAll(resp.Body)
		if err != nil {
			return nil, resp.StatusCode, fmt.Errorf("failed to read response: %w", err)
		}

		// Don't retry on client errors (4xx)
		if resp.StatusCode >= 400 && resp.StatusCode < 500 {
			return respBody, resp.StatusCode, nil
		}

		// Retry on server errors (5xx)
		if resp.StatusCode >= 500 {
			lastErr = fmt.Errorf("server error: %d", resp.StatusCode)
			continue
		}

		return respBody, resp.StatusCode, nil
	}

	return nil, 0, fmt.Errorf("request failed after %d retries: %w", maxRetries, lastErr)
}
