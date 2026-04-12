import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(6.9271, 79.8612); // Colombo center

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('Select Location', style: AppTextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          MapView(
            latitude: _center.latitude,
            longitude: _center.longitude,
            zoom: 15,
            mapController: _mapController,
            onTap: (pos, latlng) {
              setState(() => _center = latlng);
            },
          ),
          
          // Center Marker
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: AppColors.primary, size: 40),
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.black26, 
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 48), // Offset to align pin bottom
              ],
            ),
          ),

          // Bottom Action Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Selected Location', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.darkBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_searching, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${_center.latitude.toStringAsFixed(4)}, ${_center.longitude.toStringAsFixed(4)}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  RentRideButton(
                    text: 'Confirm Location',
                    onPressed: () {
                      // Return location back to previous screen
                      context.pop(_center);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
