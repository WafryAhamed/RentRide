import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  bool _agreeTerms = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms & conditions')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthApiService().register(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
      );
      if (mounted) context.push('/otp', extra: _phoneController.text);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text('Create Account', style: AppTextStyles.heading1),
                  const SizedBox(height: 8),
                  Text('Join RentRide and start your journey', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 32),

                  RentRideTextField(label: 'Full Name', hint: 'Enter your name', controller: _nameController, prefixIcon: Icons.person_outlined, validator: Validators.name),
                  const SizedBox(height: 16),
                  RentRideTextField(label: 'Email', hint: 'Enter your email', controller: _emailController, keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined, validator: Validators.email),
                  const SizedBox(height: 16),
                  RentRideTextField(label: 'Phone', hint: '+94 7X XXX XXXX', controller: _phoneController, keyboardType: TextInputType.phone, prefixIcon: Icons.phone_outlined, validator: Validators.phone),
                  const SizedBox(height: 16),
                  RentRideTextField(
                    label: 'Password', hint: 'Create a password', controller: _passwordController, obscureText: _obscure, prefixIcon: Icons.lock_outlined,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Terms
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeTerms,
                        onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: AppTextStyles.bodySmall,
                            children: [
                              TextSpan(text: 'Terms & Conditions', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  RentRideButton(text: 'Create Account', onPressed: _register, isLoading: _isLoading, icon: Icons.person_add),
                  const SizedBox(height: 24),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: AppTextStyles.bodyMedium),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text('Sign In', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
