import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});
  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  int _step = 0;
  bool _isLoading = false;
  String? _error;

  // Step 0 — Personal Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Step 1 — Vehicle Details
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();

  Future<void> _submitRegistration() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await AuthApiService().register({
        'full_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'role': 'driver',
      });
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _licensePlateController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => _step > 0 ? setState(() => _step--) : context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: Text('Register • Step ${_step + 1}/3', style: AppTextStyles.heading4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColors.accent : AppColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
            const SizedBox(height: 32),

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

            if (_step == 0) ...[
              Text('Personal Info', style: AppTextStyles.heading3),
              const SizedBox(height: 20),
              RentRideTextField(label: 'Full Name', hint: 'Enter your name', prefixIcon: Icons.person_outlined, controller: _nameController),
              const SizedBox(height: 16),
              RentRideTextField(label: 'Email', hint: 'Enter your email', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, controller: _emailController),
              const SizedBox(height: 16),
              RentRideTextField(label: 'Phone', hint: '+94 7X XXX XXXX', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, controller: _phoneController),
              const SizedBox(height: 16),
              RentRideTextField(label: 'Password', hint: 'Create a password', prefixIcon: Icons.lock_outlined, obscureText: true, controller: _passwordController),
            ] else if (_step == 1) ...[
              Text('Vehicle Details', style: AppTextStyles.heading3),
              const SizedBox(height: 20),
              RentRideTextField(label: 'Vehicle Make', hint: 'e.g. Toyota', prefixIcon: Icons.directions_car, controller: _vehicleMakeController),
              const SizedBox(height: 16),
              RentRideTextField(label: 'Vehicle Model', hint: 'e.g. Prius', prefixIcon: Icons.car_repair, controller: _vehicleModelController),
              const SizedBox(height: 16),
              RentRideTextField(label: 'License Plate', hint: 'e.g. CAB-1234', prefixIcon: Icons.confirmation_number, controller: _licensePlateController),
              const SizedBox(height: 16),
              RentRideTextField(label: 'Year', hint: 'e.g. 2022', prefixIcon: Icons.calendar_today, keyboardType: TextInputType.number, controller: _yearController),
              const SizedBox(height: 16),
              RentRideTextField(label: 'Color', hint: 'e.g. White', prefixIcon: Icons.palette, controller: _colorController),
            ] else ...[
              Text('Upload Documents', style: AppTextStyles.heading3),
              const SizedBox(height: 20),
              _DocUpload(icon: Icons.badge, label: 'National ID Card', status: 'Required'),
              _DocUpload(icon: Icons.card_membership, label: 'Driving License', status: 'Required'),
              _DocUpload(icon: Icons.car_rental, label: 'Vehicle Registration', status: 'Required'),
              _DocUpload(icon: Icons.security, label: 'Insurance Certificate', status: 'Optional'),
            ],
            const SizedBox(height: 32),

            RentRideButton(
              text: _step < 2 ? 'Continue' : 'Submit Application',
              gradient: AppColors.accentGradient,
              isLoading: _isLoading,
              onPressed: () {
                if (_step < 2) {
                  setState(() => _step++);
                } else {
                  _submitRegistration();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DocUpload extends StatelessWidget {
  final IconData icon; final String label; final String status;
  const _DocUpload({required this.icon, required this.label, required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder, style: BorderStyle.solid),
      ),
      child: Row(children: [
        Icon(icon, color: AppColors.accent, size: 24),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.labelLarge),
          Text(status, style: AppTextStyles.caption.copyWith(color: status == 'Required' ? AppColors.accent : AppColors.textMuted)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Text('Upload', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
        ),
      ]),
    );
  }
}
