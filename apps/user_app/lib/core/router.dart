import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/search_destination_screen.dart';
import '../features/booking/vehicle_selection_screen.dart';
import '../features/booking/confirm_booking_screen.dart';
import '../features/booking/searching_driver_screen.dart';
import '../features/booking/driver_found_screen.dart';
import '../features/tracking/live_tracking_screen.dart';
import '../features/payment/payment_screen.dart';
import '../features/payment/receipt_screen.dart';
import '../features/rating/rate_driver_screen.dart';
import '../features/history/ride_history_screen.dart';
import '../features/history/ride_detail_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/settings_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/travel_guide/guide_home_screen.dart';
import '../features/travel_guide/place_detail_screen.dart';
import '../features/support/help_support_screen.dart';
import '../features/support/emergency_screen.dart';
import '../features/home/main_shell.dart';
import '../features/home/location_picker_screen.dart';
import '../features/home/saved_locations_screen.dart';
import '../features/profile/change_password_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/otp', builder: (_, state) => OtpScreen(phone: state.extra as String? ?? '')),
    GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),

    // Main app shell (bottom nav)
    ShellRoute(
      builder: (_, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/history', builder: (_, __) => const RideHistoryScreen()),
        GoRoute(path: '/guide', builder: (_, __) => const GuideHomeScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),

    // Standalone routes
    GoRoute(path: '/search-destination', builder: (_, __) => const SearchDestinationScreen()),
    GoRoute(path: '/vehicle-selection', builder: (_, __) => const VehicleSelectionScreen()),
    GoRoute(path: '/confirm-booking', builder: (_, __) => const ConfirmBookingScreen()),
    GoRoute(path: '/searching-driver', builder: (_, __) => const SearchingDriverScreen()),
    GoRoute(path: '/driver-found', builder: (_, __) => const DriverFoundScreen()),
    GoRoute(path: '/live-tracking', builder: (_, __) => const LiveTrackingScreen()),
    GoRoute(path: '/payment', builder: (_, __) => const PaymentScreen()),
    GoRoute(path: '/receipt', builder: (_, __) => const ReceiptScreen()),
    GoRoute(path: '/rate-driver', builder: (_, __) => const RateDriverScreen()),
    GoRoute(path: '/ride-detail', builder: (_, __) => const RideDetailScreen()),
    GoRoute(path: '/edit-profile', builder: (_, __) => const EditProfileScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: '/place-detail', builder: (_, state) => PlaceDetailScreen(guideId: state.extra as String? ?? '')),
    GoRoute(path: '/help-support', builder: (_, __) => const HelpSupportScreen()),
    GoRoute(path: '/emergency', builder: (_, __) => const EmergencyScreen()),
    GoRoute(path: '/location-picker', builder: (_, __) => const LocationPickerScreen()),
    GoRoute(path: '/saved-locations', builder: (_, __) => const SavedLocationsScreen()),
    GoRoute(path: '/change-password', builder: (_, __) => const ChangePasswordScreen()),
  ],
);
