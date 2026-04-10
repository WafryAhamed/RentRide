import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Emergency'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.emergency, color: AppColors.error, size: 64),
                  const SizedBox(height: 16),
                  Text('Emergency SOS', style: AppTextStyles.heading2.copyWith(color: AppColors.error)),
                  const SizedBox(height: 8),
                  Text(
                    'If you are in immediate danger, press the SOS button below.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // SOS button
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.darkCard,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text('SOS Alert Sent', style: AppTextStyles.heading4),
                          content: Text('Your emergency contacts and local authorities have been notified with your current location.', style: AppTextStyles.bodyMedium),
                          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                        ),
                      );
                    },
                    child: Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error,
                        boxShadow: [
                          BoxShadow(color: AppColors.error.withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                        ],
                      ),
                      child: Center(
                        child: Text('SOS', style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 36)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick contacts
            Text('Quick Contacts', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            _EmergencyContact(icon: Icons.local_police, label: 'Police', number: '119', color: AppColors.primary),
            _EmergencyContact(icon: Icons.local_hospital, label: 'Ambulance', number: '1990', color: AppColors.error),
            _EmergencyContact(icon: Icons.local_fire_department, label: 'Fire Service', number: '110', color: AppColors.accent),
            _EmergencyContact(icon: Icons.support_agent, label: 'RentRide Support', number: '+94 11 234 5678', color: AppColors.success),
            const Spacer(),
            Text('Your location will be shared during an emergency', style: AppTextStyles.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _EmergencyContact extends StatelessWidget {
  final IconData icon; final String label; final String number; final Color color;
  const _EmergencyContact({required this.icon, required this.label, required this.number, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.labelLarge),
          Text(number, style: AppTextStyles.bodySmall),
        ])),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.phone, color: AppColors.success, size: 20),
        ),
      ]),
    );
  }
}
