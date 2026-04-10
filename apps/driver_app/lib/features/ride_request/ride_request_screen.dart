import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class RideRequestScreen extends StatelessWidget {
  const RideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Ride Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Map preview
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(height: 200, child: MapView(zoom: 13, interactive: false)),
            ),
            const SizedBox(height: 20),

            // Rider info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
              child: Row(children: [
                CircleAvatar(radius: 24, backgroundColor: AppColors.primary.withOpacity(0.2), child: const Icon(Icons.person, color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Sahan Perera', style: AppTextStyles.heading4),
                  Row(children: [const RatingStars(rating: 4.8, size: 14), const SizedBox(width: 4), Text('4.8', style: AppTextStyles.caption)]),
                ])),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.phone, color: AppColors.success, size: 22),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Route
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
              child: Column(children: [
                _LocRow(color: AppColors.mapPickup, label: 'Pickup', value: '23, Galle Road, Colombo 03'),
                Container(margin: const EdgeInsets.only(left: 5), height: 20, width: 2, color: AppColors.darkBorder),
                _LocRow(color: AppColors.mapDropoff, label: 'Drop-off', value: 'World Trade Center, Colombo 01'),
              ]),
            ),
            const SizedBox(height: 16),

            // Trip details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _TripStat(icon: Icons.route, label: 'Distance', value: '5.2 km'),
                Container(width: 1, height: 40, color: AppColors.darkBorder),
                _TripStat(icon: Icons.access_time, label: 'Duration', value: '18 min'),
                Container(width: 1, height: 40, color: AppColors.darkBorder),
                _TripStat(icon: Icons.payments, label: 'Fare', value: 'Rs. 588'),
              ]),
            ),
            const SizedBox(height: 32),

            RentRideButton(text: 'Navigate to Pickup', onPressed: () => context.pushReplacement('/active-ride'), icon: Icons.navigation, gradient: AppColors.accentGradient),
          ],
        ),
      ),
    );
  }
}

class _LocRow extends StatelessWidget {
  final Color color; final String label; final String value;
  const _LocRow({required this.color, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.caption), Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
      ])),
    ]);
  }
}

class _TripStat extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _TripStat({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(children: [Icon(icon, size: 20, color: AppColors.accent), const SizedBox(height: 4), Text(value, style: AppTextStyles.labelLarge), Text(label, style: AppTextStyles.caption)]);
  }
}
