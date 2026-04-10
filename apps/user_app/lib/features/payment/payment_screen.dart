import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success animation
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.success.withOpacity(0.15),
                  boxShadow: [BoxShadow(color: AppColors.success.withOpacity(0.2), blurRadius: 30, spreadRadius: 5)],
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 64),
              ),
              const SizedBox(height: 32),
              Text('Ride Completed!', style: AppTextStyles.heading2),
              const SizedBox(height: 8),
              Text('Thank you for riding with RentRide', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 40),

              // Payment summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  children: [
                    _Row(label: 'Driver', value: 'Kamal Silva'),
                    const SizedBox(height: 10),
                    _Row(label: 'Vehicle', value: 'Toyota Prius'),
                    const SizedBox(height: 10),
                    _Row(label: 'Distance', value: '5.2 km'),
                    const SizedBox(height: 10),
                    _Row(label: 'Duration', value: '18 min'),
                    const SizedBox(height: 10),
                    _Row(label: 'Payment', value: 'Cash'),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.darkBorder)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Fare', style: AppTextStyles.heading4),
                        Text('Rs. 588', style: AppTextStyles.priceLarge),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              RentRideButton(text: 'Rate Driver', onPressed: () => context.pushReplacement('/rate-driver'), icon: Icons.star),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push('/receipt'),
                child: Text('View Receipt', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label; final String value;
  const _Row({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: AppTextStyles.bodyMedium), Text(value, style: AppTextStyles.labelLarge)],
    );
  }
}
