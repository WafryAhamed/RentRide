import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  Future<void> _send() async {
    if (_emailController.text.isEmpty) return;
    setState(() => _isLoading = true);
    await MockAuthService.resetPassword(_emailController.text);
    if (mounted) setState(() { _isLoading = false; _sent = true; });
  }

  @override
  void dispose() { _emailController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary)),
                const SizedBox(height: 32),
                Text('Forgot Password', style: AppTextStyles.heading1),
                const SizedBox(height: 8),
                Text('Enter your email and we\'ll send you a reset link.', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 40),

                if (!_sent) ...[
                  RentRideTextField(label: 'Email', hint: 'Enter your email', controller: _emailController, keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined, validator: Validators.email),
                  const SizedBox(height: 32),
                  RentRideButton(text: 'Send Reset Link', onPressed: _send, isLoading: _isLoading, icon: Icons.send),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.success.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 56),
                        const SizedBox(height: 16),
                        Text('Email Sent!', style: AppTextStyles.heading3.copyWith(color: AppColors.success)),
                        const SizedBox(height: 8),
                        Text('Check your inbox for the reset link.', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  RentRideButton(text: 'Back to Login', onPressed: () => context.go('/login'), isOutlined: true),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
