import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Profile header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.surfaceGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 48),
                        ),
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle,
                            border: Border.all(color: AppColors.darkSurface, width: 3),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Sahan Perera', style: AppTextStyles.heading3),
                    const SizedBox(height: 4),
                    Text('sahan@rentride.lk', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(label: 'Rides', value: '42'),
                        Container(width: 1, height: 30, color: AppColors.darkBorder),
                        _StatItem(label: 'Rating', value: '4.8 ⭐'),
                        Container(width: 1, height: 30, color: AppColors.darkBorder),
                        _StatItem(label: 'Member', value: 'Jan 2024'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu items
              _MenuItem(icon: Icons.person_outline, label: 'Edit Profile', onTap: () => context.push('/edit-profile')),
              _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Locations', badge: '2', onTap: () {}),
              _MenuItem(icon: Icons.payment_outlined, label: 'Payment Methods', onTap: () {}),
              _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => context.push('/notifications')),
              _MenuItem(icon: Icons.settings_outlined, label: 'Settings', onTap: () => context.push('/settings')),
              const SizedBox(height: 8),
              const Divider(color: AppColors.darkBorder),
              const SizedBox(height: 8),
              _MenuItem(icon: Icons.help_outline, label: 'Help & Support', onTap: () => context.push('/help-support')),
              _MenuItem(icon: Icons.shield_outlined, label: 'Privacy Policy', onTap: () {}),
              _MenuItem(icon: Icons.info_outline, label: 'About RentRide', onTap: () {}),
              const SizedBox(height: 8),
              _MenuItem(
                icon: Icons.logout, label: 'Sign Out', isDestructive: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.darkCard,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text('Sign Out', style: AppTextStyles.heading4),
                      content: Text('Are you sure you want to sign out?', style: AppTextStyles.bodyMedium),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () { Navigator.pop(ctx); context.go('/login'); },
                          child: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('RentRide v${AppConstants.appVersion}', style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label; final String value;
  const _StatItem({required this.label, required this.value});
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

class _MenuItem extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final bool isDestructive; final String? badge;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.isDestructive = false, this.badge});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: (isDestructive ? AppColors.error : AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary, size: 20),
      ),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(
        color: isDestructive ? AppColors.error : AppColors.textPrimary,
      )),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text(badge!, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
            )
          : Icon(Icons.chevron_right, color: AppColors.textMuted.withOpacity(0.5), size: 20),
      onTap: onTap,
    );
  }
}
