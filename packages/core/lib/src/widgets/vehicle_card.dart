import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/vehicle_model.dart';
import '../utils/formatters.dart';

/// Card for selecting vehicle type during booking.
class VehicleCard extends StatelessWidget {
  final VehicleType type;
  final double estimatedFare;
  final int estimatedMinutes;
  final bool isSelected;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.type,
    required this.estimatedFare,
    required this.estimatedMinutes,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Vehicle icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _vehicleColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(
                child: Text(_vehicleEmoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),

            // Vehicle info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _vehicleLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _vehicleDesc,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            // Price + time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.currency(estimatedFare),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.accent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$estimatedMinutes min',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String get _vehicleEmoji {
    switch (type) {
      case VehicleType.bike: return '🏍️';
      case VehicleType.car: return '🚗';
      case VehicleType.van: return '🚐';
    }
  }

  String get _vehicleLabel {
    switch (type) {
      case VehicleType.bike: return 'Bike';
      case VehicleType.car: return 'Car';
      case VehicleType.van: return 'Van';
    }
  }

  String get _vehicleDesc {
    switch (type) {
      case VehicleType.bike: return '1 rider • Fastest';
      case VehicleType.car: return 'Up to 4 • Comfortable';
      case VehicleType.van: return 'Up to 8 • Spacious';
    }
  }

  Color get _vehicleColor {
    switch (type) {
      case VehicleType.bike: return AppColors.bikeColor;
      case VehicleType.car: return AppColors.carColor;
      case VehicleType.van: return AppColors.vanColor;
    }
  }
}
