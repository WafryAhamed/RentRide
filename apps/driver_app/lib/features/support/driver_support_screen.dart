import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DriverSupportScreen extends StatelessWidget {
  const DriverSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              const Icon(Icons.support_agent, color: Colors.black87, size: 48),
              const SizedBox(height: 12),
              Text('Driver Support', style: AppTextStyles.heading3.copyWith(color: Colors.black87)),
              const SizedBox(height: 4),
              Text('We\'re here to help 24/7', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54)),
            ]),
          ),
          const SizedBox(height: 24),

          _SupportTile(icon: Icons.account_circle, label: 'Account Issues', onTap: () {}),
          _SupportTile(icon: Icons.payments, label: 'Payment & Earnings', onTap: () {}),
          _SupportTile(icon: Icons.car_repair, label: 'Vehicle Issues', onTap: () {}),
          _SupportTile(icon: Icons.report_problem, label: 'Report a Problem', onTap: () {}),
          _SupportTile(icon: Icons.shield, label: 'Safety Concern', onTap: () {}),
          _SupportTile(icon: Icons.policy, label: 'Policies & Guidelines', onTap: () {}),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.darkBorder)),
            child: Column(children: [
              Text('Contact Us', style: AppTextStyles.heading4),
              const SizedBox(height: 12),
              _ContactRow(icon: Icons.phone, value: '+94 11 234 5678'),
              _ContactRow(icon: Icons.email, value: 'drivers@rentride.lk'),
              _ContactRow(icon: Icons.chat, value: 'Live Chat Available'),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _SupportTile({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent, size: 22),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon; final String value;
  const _ContactRow({required this.icon, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, color: AppColors.accent, size: 18), const SizedBox(width: 12),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
      ]),
    );
  }
}
