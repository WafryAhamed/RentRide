import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          MapView(
            mapController: _mapController,
            markers: [
              MapView.pickupMarker(const LatLng(AppConstants.defaultLat, AppConstants.defaultLng)),
              // Nearby drivers
              MapView.driverMarker(const LatLng(6.9295, 79.8630), heading: 45),
              MapView.driverMarker(const LatLng(6.9250, 79.8580), heading: 180),
              MapView.driverMarker(const LatLng(6.9310, 79.8560), heading: 270),
            ],
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Menu button
                  GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderRadius: 14,
                    child: const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
                    onTap: () {},
                  ),
                  const Spacer(),
                  // Notification bell
                  GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderRadius: 14,
                    onTap: () => context.push('/notifications'),
                    child: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom sheet — Where to?
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4))],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.darkBorder, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 20),

                    // Greeting
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: const Icon(Icons.person, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good Morning 👋', style: AppTextStyles.bodySmall),
                            Text('Sahan Perera', style: AppTextStyles.heading4),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search bar
                    GestureDetector(
                      onTap: () => context.push('/search-destination'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.primary, size: 22),
                            const SizedBox(width: 12),
                            Text('Where to?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text('Now', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Saved locations
                    Row(
                      children: [
                        Expanded(
                          child: _QuickLocation(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            sublabel: 'Galle Road',
                            onTap: () => context.push('/search-destination'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickLocation(
                            icon: Icons.work_rounded,
                            label: 'Work',
                            sublabel: 'WTC',
                            onTap: () => context.push('/search-destination'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),

          // My location FAB
          Positioned(
            right: 16,
            bottom: 280,
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 14,
              onTap: () => _mapController.move(
                const LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
                AppConstants.defaultZoom,
              ),
              child: const Icon(Icons.my_location, color: AppColors.primary, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLocation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;
  const _QuickLocation({required this.icon, required this.label, required this.sublabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelLarge),
                  Text(sublabel, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
