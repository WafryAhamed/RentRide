class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String wsBaseUrl = 'ws://localhost:8000/api/v1';

  // Auth endpoints
  static const String authLogin = '$baseUrl/auth/login';
  static const String authRegister = '$baseUrl/auth/register';

  // User endpoints
  static const String userProfile = '$baseUrl/users/profile';

  // Booking endpoints
  static const String rides = '$baseUrl/rides';
  static String rideStatus(String id) => '$baseUrl/rides/$id';

  // Vehicle endpoints
  static const String vehicles = '$baseUrl/vehicles';
  static String vehicleDetails(String id) => '$baseUrl/vehicles/$id';
  
  // Location endpoints (WebSocket & HTTP)
  static const String locationWs = '$wsBaseUrl/ws/location';
  static const String locationUpdate = '$baseUrl/locations/update';

  // Payment endpoints
  static const String payments = '$baseUrl/payments';
  static String paymentCollect(String id) => '$baseUrl/payments/$id/collect';
  static String paymentConfirm(String id) => '$baseUrl/payments/$id/confirm';
  
  // Notification endpoints
  static const String notifications = '$baseUrl/notifications';
  
  // Travel Guide endpoints
  static const String guides = '$baseUrl/guides/places';
}
