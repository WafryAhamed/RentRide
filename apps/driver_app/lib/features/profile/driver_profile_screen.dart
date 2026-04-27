import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: const Text('Driver Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.surfaceGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.accent.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.accent,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Kamal Silva', style: AppTextStyles.heading3),
                  Text('kamal@rentride.lk', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat('Rides', '1,250'),
                      _Stat('Rating', '4.9'),
                      _Stat('Earned', 'Rs. 285K'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vehicle card
            Text('Vehicle Details', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                children: [
                  _DetailRow('Vehicle', 'Toyota Prius'),
                  _DetailRow('Year', '2022'),
                  _DetailRow('Color', 'White'),
                  _DetailRow('License Plate', 'CAB-1234'),
                  _DetailRow('Type', 'Car (4 seats)'),
                  _DetailRow('Insurance', 'Valid until Dec 2025'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings
            _ListTile(icon: Icons.edit, label: 'Edit Profile', onTap: () {}),
            _ListTile(
              icon: Icons.car_repair,
              label: 'Update Vehicle',
              onTap: () {},
            ),
            _ListTile(
              icon: Icons.document_scanner,
              label: 'My Documents',
              onTap: () {},
            ),
            _ListTile(icon: Icons.settings, label: 'Settings', onTap: () {}),
            _ListTile(
              icon: Icons.help,
              label: 'Help & Support',
              onTap: () => context.push('/support'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.labelLarge),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value, style: AppTextStyles.labelLarge),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ListTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.accent, size: 20),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textMuted,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
