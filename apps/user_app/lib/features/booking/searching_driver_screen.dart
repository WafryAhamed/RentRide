import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'dart:math';

class SearchingDriverScreen extends StatefulWidget {
  const SearchingDriverScreen({super.key});
  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotateController = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat();

    // Simulate finding a driver after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) context.pushReplacement('/driver-found');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated search indicator
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulse
                      Container(
                        width: 180 * _pulseAnimation.value,
                        height: 180 * _pulseAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.06),
                        ),
                      ),
                      Container(
                        width: 140 * _pulseAnimation.value,
                        height: 140 * _pulseAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                      // Rotating ring
                      AnimatedBuilder(
                        animation: _rotateController,
                        builder: (context, _) {
                          return Transform.rotate(
                            angle: _rotateController.value * 2 * pi,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.transparent, width: 3),
                                gradient: SweepGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0),
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Center icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🚗', style: TextStyle(fontSize: 36)),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 48),

              Text('Finding Your Driver', style: AppTextStyles.heading2),
              const SizedBox(height: 12),
              Text(
                'Searching for nearby drivers...\nThis usually takes a few seconds.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Cancel button
              RentRideButton(
                text: 'Cancel',
                onPressed: () => context.pop(),
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
