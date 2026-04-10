/// App-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'RentRide';
  static const String appTagline = 'Your ride, your way';
  static const String appVersion = '1.0.0';

  // Map defaults (Colombo, Sri Lanka)
  static const double defaultLat = 6.9271;
  static const double defaultLng = 79.8612;
  static const double defaultZoom = 14.0;

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration animVerySlow = Duration(milliseconds: 1000);

  // API
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Onboarding
  static const List<Map<String, String>> onboardingData = [
    {
      'title': 'Book Your Ride',
      'description': 'Choose from bikes, cars, or vans. Get picked up in minutes from anywhere in Sri Lanka.',
      'icon': '🚗',
    },
    {
      'title': 'Track in Real-Time',
      'description': 'Watch your driver approach on the live map. Know exactly when they\'ll arrive.',
      'icon': '📍',
    },
    {
      'title': 'Explore Sri Lanka',
      'description': 'Discover amazing places with our built-in travel guide. Hotels, restaurants, and hidden gems.',
      'icon': '🌍',
    },
  ];
}
