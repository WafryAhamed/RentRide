import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class RideDetailScreen extends StatelessWidget {
  const RideDetailScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Center(child: StatusBadge.completed()),
            const SizedBox(height: 20),

            // Map preview
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 180,
                child: MapView(
                  interactive: false,
                  zoom: 13,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Route
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
              child: Column(
                children: [
                  _LocRow(color: AppColors.mapPickup, label: 'Pickup', value: '23, Galle Road, Colombo 03', time: '8:30 AM'),
                  Container(margin: const EdgeInsets.only(left: 5), height: 20, width: 2, color: AppColors.darkBorder),
                  _LocRow(color: AppColors.mapDropoff, label: 'Drop-off', value: 'World Trade Center, Colombo 01', time: '8:48 AM'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Driver
            Text('Driver', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
              child: Row(
                children: [
                  CircleAvatar(radius: 22, backgroundColor: AppColors.primary.withOpacity(0.2), child: const Icon(Icons.person, color: AppColors.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Kamal Silva', style: AppTextStyles.labelLarge),
                    Row(children: [const RatingStars(rating: 4.9, size: 14), const SizedBox(width: 4), Text('4.9', style: AppTextStyles.caption)]),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('Toyota Prius', style: AppTextStyles.labelMedium),
                    Text('CAB-1234', style: AppTextStyles.caption),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Trip summary
            Text('Trip Summary', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
              child: Column(
                children: [
                  _InfoRow('Distance', '5.2 km'),
                  _InfoRow('Duration', '18 min'),
                  _InfoRow('Base Fare', 'Rs. 250'),
                  _InfoRow('Distance Fare', 'Rs. 338'),
                  const Divider(color: AppColors.darkBorder, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Total', style: AppTextStyles.heading4), Text('Rs. 588', style: AppTextStyles.priceMedium)],
                  ),
                  const SizedBox(height: 8),
                  _InfoRow('Payment', 'Cash'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(child: RentRideButton(text: 'Report Issue', onPressed: () {}, isOutlined: true)),
                const SizedBox(width: 12),
                Expanded(child: RentRideButton(text: 'Rebook', onPressed: () => context.go('/vehicle-selection'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LocRow extends StatelessWidget {
  final Color color; final String label; final String value; final String time;
  const _LocRow({required this.color, required this.label, required this.value, required this.time});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
      ])),
      Text(time, style: AppTextStyles.labelSmall),
    ]);
  }
}

class _InfoRow extends StatelessWidget {
  final String label; final String value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTextStyles.bodyMedium), Text(value, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary))]),
    );
  }
}
