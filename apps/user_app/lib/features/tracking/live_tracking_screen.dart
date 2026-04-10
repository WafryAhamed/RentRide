import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});
  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final _mapController = MapController();
  late Timer _timer;
  int _step = 0;
  String _status = 'Driver is on the way';
  String _statusEmoji = '🚗';

  // Simulated driver positions
  final List<LatLng> _driverPath = const [
    LatLng(6.9310, 79.8560),
    LatLng(6.9305, 79.8575),
    LatLng(6.9298, 79.8588),
    LatLng(6.9290, 79.8598),
    LatLng(6.9282, 79.8607),
    LatLng(6.9275, 79.8612),
    LatLng(6.9271, 79.8612), // At pickup
  ];

  LatLng get _currentDriverPos =>
      _step < _driverPath.length ? _driverPath[_step] : _driverPath.last;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_step < _driverPath.length - 1) {
        setState(() => _step++);
        _mapController.move(_currentDriverPos, 16);
      } else {
        timer.cancel();
        setState(() {
          _status = 'Driver has arrived!';
          _statusEmoji = '✅';
        });
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
    final pickup = const LatLng(AppConstants.defaultLat, AppConstants.defaultLng);
    final dropoff = const LatLng(6.9344, 79.8428);

    return Scaffold(
      body: Stack(
        children: [
          // Map
          MapView(
            mapController: _mapController,
            latitude: _currentDriverPos.latitude,
            longitude: _currentDriverPos.longitude,
            zoom: 15,
            markers: [
              MapView.pickupMarker(pickup),
              MapView.dropoffMarker(dropoff),
              MapView.driverMarker(_currentDriverPos, heading: 220),
            ],
            polylines: [
              MapView.routePolyline([
                _currentDriverPos,
                pickup,
                const LatLng(6.9300, 79.8550),
                const LatLng(6.9330, 79.8480),
                dropoff,
              ]),
            ],
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GlassCard(
              padding: const EdgeInsets.all(10),
              borderRadius: 12,
              onTap: () => context.go('/home'),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
            ),
          ),

          // Status pill
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
                  Text(_statusEmoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(_status, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),

          // Bottom driver info
          Positioned(
            left: 0, right: 0, bottom: 0,
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
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.darkBorder, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            child: const Icon(Icons.person, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kamal Silva', style: AppTextStyles.heading4),
                                Text('Toyota Prius • CAB-1234', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _CircleBtn(icon: Icons.phone, onTap: () {}),
                              const SizedBox(width: 8),
                              _CircleBtn(icon: Icons.chat, onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // ETA and trip info
                      Row(
                        children: [
                          _MiniInfo(label: 'ETA', value: '${7 - _step} min', icon: Icons.access_time),
                          const SizedBox(width: 12),
                          _MiniInfo(label: 'Distance', value: '5.2 km', icon: Icons.route),
                          const SizedBox(width: 12),
                          _MiniInfo(label: 'Fare', value: 'Rs. 588', icon: Icons.payments),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_status == 'Driver has arrived!')
                        RentRideButton(
                          text: 'Complete Ride',
                          onPressed: () => context.pushReplacement('/payment'),
                          icon: Icons.check_circle,
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
}

class _CircleBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String label; final String value; final IconData icon;
  const _MiniInfo({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.darkBorder)),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.labelMedium),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
