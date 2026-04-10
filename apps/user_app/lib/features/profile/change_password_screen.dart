import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Typically call AuthRepository here. For mock, just show success.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!'), backgroundColor: AppColors.success),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('Change Password', style: AppTextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Icon(Icons.lock_reset, size: 64, color: AppColors.primary),
                const SizedBox(height: 24),
                Text(
                  'Create a robust password to keep your RentRide account secure.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                RentRideTextField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),
                
                RentRideTextField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: 'Enter your new password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),
                
                RentRideTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Re-enter your new password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (val) {
                    if (val != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 48),
                CustomButton(
                  text: 'Update Password',
                  onPressed: _handleChangePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
