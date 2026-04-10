import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter/services.dart';

class DriverOtpScreen extends StatefulWidget {
  final String phone;
  const DriverOtpScreen({super.key, required this.phone});

  @override
  State<DriverOtpScreen> createState() => _DriverOtpScreenState();
}

class _DriverOtpScreenState extends State<DriverOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _verifyOtp() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 4) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          // Assuming successful verification, route to upload documents or dashboard directly
          context.go('/document-upload'); 
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 4 digits'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: Text('Verification', style: AppTextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter OTP Code', style: AppTextStyles.heading2),
              const SizedBox(height: 12),
              Text('Code has been sent to ${widget.phone}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: 32),
              
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text('Resend Code in 00:59', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
                ),
              ),
              const Spacer(),
              
              RentRideButton(
                text: 'Verify Account',
                gradient: AppColors.accentGradient,
                isLoading: _isLoading,
                onPressed: _verifyOtp,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          style: AppTextStyles.heading2,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isNotEmpty && index == 3) {
              _focusNodes[index].unfocus();
              _verifyOtp();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
