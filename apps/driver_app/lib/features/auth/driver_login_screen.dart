import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});
  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _emailController = TextEditingController(text: 'kamal@rentride.lk');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscure = true;
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await AuthApiService().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() { _emailController.dispose(); _passwordController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(16)),
                  child: const Center(child: Text('🚕', style: TextStyle(fontSize: 32))),
                ),
                const SizedBox(height: 32),
                Text('Welcome, Driver', style: AppTextStyles.heading1),
                const SizedBox(height: 8),
                Text('Sign in to start earning', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 40),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: Colors.redAccent))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                RentRideTextField(label: 'Email', hint: 'Enter your email', controller: _emailController, prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                RentRideTextField(
                  label: 'Password', hint: 'Enter your password', controller: _passwordController, obscureText: _obscure, prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted, size: 20), onPressed: () => setState(() => _obscure = !_obscure)),
                ),
                const SizedBox(height: 32),
                RentRideButton(text: 'Sign In', onPressed: _login, isLoading: _isLoading, gradient: AppColors.accentGradient),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Want to drive? ", style: AppTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => context.push('/register'),
                        child: Text('Register Now', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
