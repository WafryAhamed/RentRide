import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DriverFoundScreen extends StatefulWidget {
  const DriverFoundScreen({super.key});
  @override
  State<DriverFoundScreen> createState() => _DriverFoundScreenState();
}

class _DriverFoundScreenState extends State<DriverFoundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideUp;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _slideUp = Tween<double>(begin: 100, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Opacity(
            opacity: _fadeIn.value,
            child: Transform.translate(
              offset: Offset(0, _slideUp.value),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Spacer(),
                      // Success check
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.success.withOpacity(0.15),
                          boxShadow: [BoxShadow(color: AppColors.success.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)],
                        ),
                        child: const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                      ),
                      const SizedBox(height: 24),
                      Text('Driver Found!', style: AppTextStyles.heading2),
                      const SizedBox(height: 8),
                      Text('Your driver is on the way', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 40),

                      // Driver card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard, borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.primary.withOpacity(0.2),
                                  child: const Icon(Icons.person, color: AppColors.primary, size: 32),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Kamal Silva', style: AppTextStyles.heading4),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const RatingStars(rating: 4.9, size: 16),
                                          const SizedBox(width: 6),
                                          Text('4.9', style: AppTextStyles.labelMedium),
                                          Text(' • 1,250 rides', style: AppTextStyles.caption),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: AppColors.darkBorder),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _VehicleInfo(label: 'Vehicle', value: 'Toyota Prius'),
                                _VehicleInfo(label: 'Plate', value: 'CAB-1234'),
                                _VehicleInfo(label: 'Color', value: 'White'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.access_time, color: AppColors.primary, size: 18),
                                  const SizedBox(width: 8),
                                  Text('Arriving in ~5 min', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _ActionBtn(icon: Icons.phone, label: 'Call', onTap: () {}),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionBtn(icon: Icons.chat, label: 'Chat', onTap: () {}),
                          ),
                        ],
                      ),
                      const Spacer(),

                      RentRideButton(
                        text: 'Track Driver',
                        onPressed: () => context.pushReplacement('/live-tracking'),
                        icon: Icons.map,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go('/home'),
                        child: Text('Cancel Ride', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VehicleInfo extends StatelessWidget {
  final String label; final String value;
  const _VehicleInfo({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.labelLarge),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkCard, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.labelLarge),
          ],
        ),
      ),
    );
  }
}
