import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});
  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  final _mapController = MapController();
  String _phase = 'navigating'; // navigating, arrived, inProgress, completed
  late Timer _timer;
  int _step = 0;

  final List<LatLng> _toPickup = const [
    LatLng(6.9310, 79.8560),
    LatLng(6.9298, 79.8588),
    LatLng(6.9282, 79.8607),
    LatLng(6.9271, 79.8612),
  ];

  LatLng get _currentPos =>
      _step < _toPickup.length ? _toPickup[_step] : _toPickup.last;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (_phase == 'navigating' && _step < _toPickup.length - 1) {
        setState(() => _step++);
        _mapController.move(_currentPos, 16);
      } else if (_phase == 'navigating') {
        t.cancel();
        setState(() => _phase = 'arrived');
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapView(
            mapController: _mapController,
            latitude: _currentPos.latitude,
            longitude: _currentPos.longitude,
            zoom: 15,
            markers: [
              MapView.pickupMarker(
                const LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
              ),
              MapView.dropoffMarker(const LatLng(6.9344, 79.8428)),
              MapView.driverMarker(_currentPos, heading: 220),
            ],
          ),

          // Back
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GlassCard(
              padding: const EdgeInsets.all(10),
              borderRadius: 12,
              onTap: () => context.go('/dashboard'),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Phase badge
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 60,
            right: 60,
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              borderRadius: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _phase == 'navigating'
                        ? Icons.navigation
                        : _phase == 'arrived'
                        ? Icons.flag
                        : _phase == 'inProgress'
                        ? Icons.directions_car
                        : Icons.check_circle,
                    color: _phase == 'completed'
                        ? AppColors.success
                        : AppColors.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _phaseLabel,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.darkBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Rider info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sahan Perera',
                                  style: AppTextStyles.heading4,
                                ),
                                Text(
                                  'Rider • 4.8',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: AppColors.success,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Trip info
                      Row(
                        children: [
                          _MiniInfo(label: 'Distance', value: '5.2 km'),
                          const SizedBox(width: 10),
                          _MiniInfo(label: 'Duration', value: '18 min'),
                          const SizedBox(width: 10),
                          _MiniInfo(label: 'Fare', value: 'Rs. 588'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Action button
                      if (_phase == 'arrived')
                        RentRideButton(
                          text: 'Start Ride',
                          gradient: AppColors.accentGradient,
                          icon: Icons.play_arrow,
                          onPressed: () =>
                              setState(() => _phase = 'inProgress'),
                        ),
                      if (_phase == 'inProgress')
                        RentRideButton(
                          text: 'End Ride',
                          icon: Icons.stop_circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.success, Color(0xFF059669)],
                          ),
                          onPressed: () {
                            setState(() => _phase = 'completed');
                            Future.delayed(const Duration(seconds: 1), () {
                              if (mounted) context.go('/dashboard');
                            });
                          },
                        ),
                      if (_phase == 'navigating')
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Navigating to pickup...',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_phase == 'completed')
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ride Completed! Rs. 588 earned',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _phaseLabel {
    switch (_phase) {
      case 'navigating':
        return 'Navigating to pickup';
      case 'arrived':
        return 'Arrived at pickup';
      case 'inProgress':
        return 'Ride in progress';
      case 'completed':
        return 'Ride completed!';
      default:
        return '';
    }
  }
}

class _MiniInfo extends StatelessWidget {
  final String label;
  final String value;
  const _MiniInfo({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.labelMedium),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
