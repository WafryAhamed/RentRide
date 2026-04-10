import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Receipt'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share, size: 20)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.download, size: 20)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Receipt card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.darkCard, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                children: [
                  // Logo
                  const Text('🚗', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text('RentRide', style: AppTextStyles.heading3),
                  Text('Trip Receipt', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.darkBorder),
                  const SizedBox(height: 16),

                  _ReceiptRow('Date', Formatters.date(DateTime.now())),
                  _ReceiptRow('Time', Formatters.time(DateTime.now())),
                  _ReceiptRow('Ride ID', '#RR-2024-0042'),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.darkBorder),
                  const SizedBox(height: 16),

                  _ReceiptRow('From', '23, Galle Road, Colombo 03'),
                  _ReceiptRow('To', 'World Trade Center, Colombo 01'),
                  _ReceiptRow('Distance', '5.2 km'),
                  _ReceiptRow('Duration', '18 min'),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.darkBorder),
                  const SizedBox(height: 16),

                  _ReceiptRow('Base Fare', 'Rs. 250'),
                  _ReceiptRow('Distance Charge', 'Rs. 338'),
                  _ReceiptRow('Discount', '-Rs. 0'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTextStyles.heading4),
                        Text('Rs. 588', style: AppTextStyles.priceMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.darkBorder),
                  const SizedBox(height: 16),
                  _ReceiptRow('Payment Method', 'Cash'),
                  _ReceiptRow('Driver', 'Kamal Silva'),
                  _ReceiptRow('Vehicle', 'Toyota Prius - CAB-1234'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            RentRideButton(text: 'Done', onPressed: () => context.go('/home')),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label; final String value;
  const _ReceiptRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(width: 16),
          Flexible(child: Text(value, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
