import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                const Icon(Icons.support_agent, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text('How can we help?', style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text('We are here for you 24/7', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Emergency
          GestureDetector(
            onTap: () => context.push('/emergency'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.emergency, color: AppColors.error, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Emergency SOS', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
                  Text('Get immediate help in an emergency', style: AppTextStyles.caption),
                ])),
                const Icon(Icons.chevron_right, color: AppColors.error),
              ]),
            ),
          ),
          const SizedBox(height: 24),

          Text('Frequently Asked Questions', style: AppTextStyles.heading4),
          const SizedBox(height: 12),

          _FaqTile(q: 'How do I book a ride?', a: 'Open the app, enter your destination, select a vehicle type, and tap "Book Now". A nearby driver will be assigned to you.'),
          _FaqTile(q: 'How do I cancel a ride?', a: 'You can cancel a ride before the driver arrives from the tracking screen. Cancellation may incur a fee after the driver is en route.'),
          _FaqTile(q: 'How is the fare calculated?', a: 'Fare = Base fare + (Distance × Rate per km). Rates vary by vehicle type. Surge pricing may apply during peak hours.'),
          _FaqTile(q: 'How do I contact my driver?', a: 'Once your driver is assigned, use the Call or Chat buttons on the tracking screen.'),
          _FaqTile(q: 'Is my ride insured?', a: 'All RentRide trips include basic passenger insurance for your safety.'),
          const SizedBox(height: 24),

          Text('Contact Us', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          _ContactTile(icon: Icons.email, label: 'support@rentride.lk', onTap: () {}),
          _ContactTile(icon: Icons.phone, label: '+94 11 234 5678', onTap: () {}),
          _ContactTile(icon: Icons.chat, label: 'Live Chat', onTap: () {}),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String q; final String a;
  const _FaqTile({required this.q, required this.a});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
      child: ExpansionTile(
        title: Text(q, style: AppTextStyles.labelLarge),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textMuted,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [Text(a, style: AppTextStyles.bodyMedium.copyWith(height: 1.5))],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ContactTile({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }
}
