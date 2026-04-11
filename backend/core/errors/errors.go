package errors

import "fmt"

// AppError represents a structured application error
type AppError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
	Service string `json:"service,omitempty"`
	Err     error  `json:"-"`
}

func (e *AppError) Error() string {
	if e.Err != nil {
		return fmt.Sprintf("[%s] %s: %v", e.Service, e.Message, e.Err)
	}
	return fmt.Sprintf("[%s] %s", e.Service, e.Message)
}

func (e *AppError) Unwrap() error {
	return e.Err
}

// Standard error constructors

func NotFound(service, message string) *AppError {
	return &AppError{Code: 404, Message: message, Service: service}
}

func BadRequest(service, message string) *AppError {
	return &AppError{Code: 400, Message: message, Service: service}
}

func Unauthorized(service, message string) *AppError {
	return &AppError{Code: 401, Message: message, Service: service}
}

func Forbidden(service, message string) *AppError {
	return &AppError{Code: 403, Message: message, Service: service}
}

func Conflict(service, message string) *AppError {
	return &AppError{Code: 409, Message: message, Service: service}
}

func Internal(service string, err error) *AppError {
	return &AppError{Code: 500, Message: "Internal server error", Service: service, Err: err}
}

// Wrap wraps an existing error with context
func Wrap(service, message string, err error) *AppError {
	return &AppError{Code: 500, Message: message, Service: service, Err: err}
}
