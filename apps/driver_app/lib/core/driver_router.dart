import 'package:go_router/go_router.dart';
import '../features/auth/driver_splash_screen.dart';
import '../features/auth/driver_login_screen.dart';
import '../features/auth/driver_register_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/ride_request/ride_request_screen.dart';
import '../features/active_ride/active_ride_screen.dart';
import '../features/earnings/earnings_screen.dart';
import '../features/history/driver_history_screen.dart';
import '../features/ratings/driver_ratings_screen.dart';
import '../features/profile/driver_profile_screen.dart';
import '../features/notifications/driver_notifications_screen.dart';
import '../features/support/driver_support_screen.dart';
import '../features/auth/document_upload_screen.dart';
import '../features/auth/driver_otp_screen.dart';

final driverRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const DriverSplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const DriverLoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const DriverRegisterScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/ride-request', builder: (_, __) => const RideRequestScreen()),
    GoRoute(path: '/active-ride', builder: (_, __) => const ActiveRideScreen()),
    GoRoute(path: '/earnings', builder: (_, __) => const EarningsScreen()),
    GoRoute(path: '/history', builder: (_, __) => const DriverHistoryScreen()),
    GoRoute(path: '/ratings', builder: (_, __) => const DriverRatingsScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const DriverProfileScreen()),
    GoRoute(path: '/notifications', builder: (_, __) => const DriverNotificationsScreen()),
    GoRoute(path: '/support', builder: (_, __) => const DriverSupportScreen()),
    GoRoute(path: '/document-upload', builder: (_, __) => const DocumentUploadScreen()),
    GoRoute(path: '/otp', builder: (_, state) => DriverOtpScreen(phone: state.extra as String? ?? '')),
  ],
);
