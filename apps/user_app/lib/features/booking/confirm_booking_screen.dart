import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class ConfirmBookingScreen extends StatefulWidget {
  const ConfirmBookingScreen({super.key});
  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  String _paymentMethod = 'Cash';
  bool _isLoading = false;

  Future<void> _confirmBooking() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      context.push('/searching-driver');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Confirm Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                children: [
                  _DetailRow(icon: Icons.circle, iconColor: AppColors.mapPickup, label: 'Pickup', value: '23, Galle Road, Colombo 03'),
                  const Padding(padding: EdgeInsets.only(left: 10), child: SizedBox(height: 20, child: VerticalDivider(color: AppColors.darkBorder, width: 2))),
                  _DetailRow(icon: Icons.circle, iconColor: AppColors.mapDropoff, label: 'Drop-off', value: 'World Trade Center, Colombo 01'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ride details
            Text('Ride Details', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                children: [
                  _SummaryRow(label: 'Vehicle Type', value: '🚗 Car', valueStyle: AppTextStyles.labelLarge),
                  const Divider(color: AppColors.darkBorder, height: 24),
                  _SummaryRow(label: 'Distance', value: '5.2 km'),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Estimated Time', value: '18 min'),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Base Fare', value: 'Rs. 250'),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Distance Fare', value: 'Rs. 338'),
                  const Divider(color: AppColors.darkBorder, height: 24),
                  _SummaryRow(label: 'Total', value: 'Rs. 588', valueStyle: AppTextStyles.priceMedium),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment method
            Text('Payment Method', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            _PaymentOption(
              icon: Icons.money, label: 'Cash', isSelected: _paymentMethod == 'Cash',
              onTap: () => setState(() => _paymentMethod = 'Cash'),
            ),
            const SizedBox(height: 8),
            _PaymentOption(
              icon: Icons.credit_card, label: 'Card (Mock)', isSelected: _paymentMethod == 'Card',
              onTap: () => setState(() => _paymentMethod = 'Card'),
            ),
            const SizedBox(height: 20),

            // Promo code
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.darkCard, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, color: AppColors.accent, size: 20),
                  const SizedBox(width: 12),
                  Text('Apply Promo Code', style: AppTextStyles.bodyMedium),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 32),

            RentRideButton(text: 'Book Now', onPressed: _confirmBooking, isLoading: _isLoading, icon: Icons.check),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon; final Color iconColor; final String label; final String value;
  const _DetailRow({required this.icon, required this.iconColor, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 10, color: iconColor),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
        ])),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label; final String value; final TextStyle? valueStyle;
  const _SummaryRow({required this.label, required this.value, this.valueStyle});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: AppTextStyles.bodyMedium), Text(value, style: valueStyle ?? AppTextStyles.labelLarge)],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon; final String label; final bool isSelected; final VoidCallback onTap;
  const _PaymentOption({required this.icon, required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.darkBorder, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
