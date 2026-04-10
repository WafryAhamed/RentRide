import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = true;
  bool _locationSharing = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle('Preferences'),
          _ToggleTile(icon: Icons.notifications, label: 'Push Notifications', value: _notifications, onChanged: (v) => setState(() => _notifications = v)),
          _ToggleTile(icon: Icons.dark_mode, label: 'Dark Mode', value: _darkMode, onChanged: (v) => setState(() => _darkMode = v)),
          _ToggleTile(icon: Icons.location_on, label: 'Share Live Location', value: _locationSharing, onChanged: (v) => setState(() => _locationSharing = v)),
          _TapTile(icon: Icons.language, label: 'Language', value: _language, onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.darkSurface,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (ctx) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Language', style: AppTextStyles.heading4),
                    const SizedBox(height: 16),
                    ...['English', 'සිංහල', 'தமிழ்'].map((lang) => ListTile(
                      title: Text(lang, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                      trailing: _language == lang ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                      onTap: () { setState(() => _language = lang); Navigator.pop(ctx); },
                    )),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          _SectionTitle('Security'),
          _TapTile(icon: Icons.lock, label: 'Change Password', onTap: () {}),
          _TapTile(icon: Icons.fingerprint, label: 'Biometric Login', value: 'Enabled', onTap: () {}),
          _TapTile(icon: Icons.devices, label: 'Active Sessions', value: '1 device', onTap: () {}),
          const SizedBox(height: 24),
          _SectionTitle('Data'),
          _TapTile(icon: Icons.download, label: 'Download My Data', onTap: () {}),
          _TapTile(icon: Icons.delete_forever, label: 'Delete Account', isDestructive: true, onTap: () {}),
          const SizedBox(height: 32),
          Center(child: Text('RentRide v${AppConstants.appVersion}', style: AppTextStyles.caption)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(title, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon; final String label; final bool value; final ValueChanged<bool> onChanged;
  const _ToggleTile({required this.icon, required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
      trailing: Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppColors.primary),
    );
  }
}

class _TapTile extends StatelessWidget {
  final IconData icon; final String label; final String? value; final VoidCallback onTap; final bool isDestructive;
  const _TapTile({required this.icon, required this.label, this.value, required this.onTap, this.isDestructive = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary, size: 22),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: isDestructive ? AppColors.error : AppColors.textPrimary)),
      trailing: value != null
          ? Text(value!, style: AppTextStyles.caption)
          : Icon(Icons.chevron_right, color: AppColors.textMuted.withOpacity(0.5), size: 20),
      onTap: onTap,
    );
  }
}
