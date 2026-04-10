import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});
  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  VehicleType _selectedType = VehicleType.car;
  final double _distance = 5.2;

  double get _estimatedFare => MockRideService.calculateFare(_distance, _selectedType);
  int get _estimatedTime {
    switch (_selectedType) {
      case VehicleType.bike: return 12;
      case VehicleType.car: return 18;
      case VehicleType.van: return 22;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text('Choose Your Ride', style: AppTextStyles.heading3),
                ],
              ),
            ),

            // Route summary
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                children: [
                  _RoutePoint(color: AppColors.mapPickup, label: 'Pickup', address: '23, Galle Road, Colombo 03'),
                  Container(margin: const EdgeInsets.only(left: 15), height: 24, width: 2, color: AppColors.darkBorder),
                  _RoutePoint(color: AppColors.mapDropoff, label: 'Drop-off', address: 'World Trade Center, Colombo 01'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _InfoChip(icon: Icons.route, label: '$_distance km'),
                      _InfoChip(icon: Icons.access_time, label: '$_estimatedTime min'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Available Rides', style: AppTextStyles.labelLarge),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  VehicleCard(
                    type: VehicleType.bike,
                    estimatedFare: MockRideService.calculateFare(_distance, VehicleType.bike),
                    estimatedMinutes: 12,
                    isSelected: _selectedType == VehicleType.bike,
                    onTap: () => setState(() => _selectedType = VehicleType.bike),
                  ),
                  const SizedBox(height: 10),
                  VehicleCard(
                    type: VehicleType.car,
                    estimatedFare: MockRideService.calculateFare(_distance, VehicleType.car),
                    estimatedMinutes: 18,
                    isSelected: _selectedType == VehicleType.car,
                    onTap: () => setState(() => _selectedType = VehicleType.car),
                  ),
                  const SizedBox(height: 10),
                  VehicleCard(
                    type: VehicleType.van,
                    estimatedFare: MockRideService.calculateFare(_distance, VehicleType.van),
                    estimatedMinutes: 22,
                    isSelected: _selectedType == VehicleType.van,
                    onTap: () => setState(() => _selectedType = VehicleType.van),
                  ),
                ],
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                border: Border(top: BorderSide(color: AppColors.darkBorder)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Fare', style: AppTextStyles.bodyMedium),
                        Text(Formatters.currency(_estimatedFare), style: AppTextStyles.priceMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    RentRideButton(
                      text: 'Confirm Ride',
                      onPressed: () => context.push('/confirm-booking'),
                      icon: Icons.check_circle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final Color color; final String label; final String address;
  const _RoutePoint({required this.color, required this.label, required this.address});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(address, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon; final String label;
  const _InfoChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16, color: AppColors.primary), const SizedBox(width: 6), Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary))],
      ),
    );
  }
}
