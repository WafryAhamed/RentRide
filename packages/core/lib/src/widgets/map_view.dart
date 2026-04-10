import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';

/// OpenStreetMap widget with customizable markers and polylines.
class MapView extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final MapController? mapController;
  final bool interactive;
  final void Function(TapPosition, LatLng)? onTap;

  const MapView({
    super.key,
    this.latitude = AppConstants.defaultLat,
    this.longitude = AppConstants.defaultLng,
    this.zoom = AppConstants.defaultZoom,
    this.markers = const [],
    this.polylines = const [],
    this.mapController,
    this.interactive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(latitude, longitude),
        initialZoom: zoom,
        onTap: onTap,
        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.osmTileUrl,
          userAgentPackageName: 'com.rentride.app',
        ),
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }

  /// Helper to create a pickup marker.
  static Marker pickupMarker(LatLng point) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: const _PulsingDot(color: AppColors.mapPickup),
    );
  }

  /// Helper to create a dropoff marker.
  static Marker dropoffMarker(LatLng point) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mapDropoff,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.mapDropoff.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.flag, color: Colors.white, size: 20),
      ),
    );
  }

  /// Helper to create a driver marker.
  static Marker driverMarker(LatLng point, {double? heading}) {
    return Marker(
      point: point,
      width: 44,
      height: 44,
      child: Transform.rotate(
        angle: (heading ?? 0) * 3.14159 / 180,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.navigation, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  /// Helper for route polyline.
  static Polyline routePolyline(List<LatLng> points) {
    return Polyline(
      points: points,
      color: AppColors.mapRoute,
      strokeWidth: 4,
    );
  }
}

/// Animated pulsing dot for pickup location.
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(0.2 * _animation.value),
          ),
          child: Center(
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
