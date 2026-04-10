import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isOnline = false;
  bool _showRideRequest = false;

  void _toggleOnline() {
    setState(() => _isOnline = !_isOnline);
    if (_isOnline) {
      // Simulate ride request after 3s
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isOnline) setState(() => _showRideRequest = true);
      });
    } else {
      setState(() => _showRideRequest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          MapView(
            markers: [
              MapView.driverMarker(const LatLng(AppConstants.defaultLat, AppConstants.defaultLng)),
            ],
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Menu
                  GlassCard(
                    padding: const EdgeInsets.all(12), borderRadius: 14,
                    onTap: () => _showDriverMenu(context),
                    child: const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
                  ),
                  const Spacer(),
                  // Online/Offline toggle
                  GestureDetector(
                    onTap: _toggleOnline,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _isOnline ? AppColors.success : AppColors.darkCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _isOnline ? AppColors.success : AppColors.darkBorder),
                        boxShadow: _isOnline ? [BoxShadow(color: AppColors.success.withOpacity(0.3), blurRadius: 12)] : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(
                              color: _isOnline ? Colors.white : AppColors.textMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isOnline ? 'Online' : 'Offline',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: _isOnline ? Colors.white : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Notifications
                  GlassCard(
                    padding: const EdgeInsets.all(12), borderRadius: 14,
                    onTap: () => context.push('/notifications'),
                    child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                  ),
                ],
              ),
            ),
          ),

          // Bottom info
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.darkBorder, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 16),
                      // Driver info
                      Row(
                        children: [
                          CircleAvatar(radius: 24, backgroundColor: AppColors.accent.withOpacity(0.2), child: const Icon(Icons.person, color: AppColors.accent)),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Kamal Silva', style: AppTextStyles.heading4),
                            Text('Toyota Prius • CAB-1234', style: AppTextStyles.bodySmall),
                          ])),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Row(children: [const Icon(Icons.star, size: 16, color: AppColors.starFilled), const SizedBox(width: 2), Text('4.9', style: AppTextStyles.labelLarge)]),
                            Text('1,250 rides', style: AppTextStyles.caption),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Today's stats
                      Row(
                        children: [
                          _DashStat(icon: Icons.route, label: 'Trips', value: '3', color: AppColors.primary),
                          const SizedBox(width: 10),
                          _DashStat(icon: Icons.payments, label: 'Earned', value: 'Rs. 2,450', color: AppColors.success),
                          const SizedBox(width: 10),
                          _DashStat(icon: Icons.access_time, label: 'Online', value: '4h 12m', color: AppColors.accent),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: RentRideButton(text: 'Earnings', onPressed: () => context.push('/earnings'), isOutlined: true)),
                          const SizedBox(width: 12),
                          Expanded(child: RentRideButton(text: 'History', onPressed: () => context.push('/history'), isOutlined: true)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Ride request popup
          if (_showRideRequest)
            _RideRequestPopup(
              onAccept: () { setState(() => _showRideRequest = false); context.push('/ride-request'); },
              onReject: () => setState(() => _showRideRequest = false),
            ),
        ],
      ),
    );
  }

  void _showDriverMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MenuBtn(icon: Icons.person, label: 'Profile', onTap: () { Navigator.pop(ctx); context.push('/profile'); }),
            _MenuBtn(icon: Icons.star, label: 'Ratings', onTap: () { Navigator.pop(ctx); context.push('/ratings'); }),
            _MenuBtn(icon: Icons.help, label: 'Support', onTap: () { Navigator.pop(ctx); context.push('/support'); }),
            _MenuBtn(icon: Icons.logout, label: 'Sign Out', isDestructive: true, onTap: () { Navigator.pop(ctx); context.go('/login'); }),
          ],
        ),
      ),
    );
  }
}

class _DashStat extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color color;
  const _DashStat({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.labelLarge),
          Text(label, style: AppTextStyles.caption),
        ]),
      ),
    );
  }
}

class _RideRequestPopup extends StatefulWidget {
  final VoidCallback onAccept; final VoidCallback onReject;
  const _RideRequestPopup({required this.onAccept, required this.onReject});
  @override
  State<_RideRequestPopup> createState() => _RideRequestPopupState();
}

class _RideRequestPopupState extends State<_RideRequestPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..forward();
    _controller.addStatusListener((s) { if (s == AnimationStatus.completed) widget.onReject(); });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16, right: 16, top: MediaQuery.of(context).padding.top + 80,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.darkCard, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent, width: 2),
            boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Timer
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => LinearProgressIndicator(
                  value: 1 - _controller.value,
                  backgroundColor: AppColors.darkBorder,
                  valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Text('New Ride Request!', style: AppTextStyles.heading4.copyWith(color: AppColors.accent)),
              const SizedBox(height: 12),
              Row(children: [
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.mapPickup, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text('23, Galle Road, Colombo 03', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.mapDropoff, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text('World Trade Center, Colombo 01', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('5.2 km', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                Text('~18 min', style: AppTextStyles.labelMedium),
                Text('Rs. 588', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent)),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: RentRideButton(text: 'Reject', onPressed: widget.onReject, isOutlined: true)),
                const SizedBox(width: 12),
                Expanded(child: RentRideButton(text: 'Accept', onPressed: widget.onAccept, gradient: AppColors.accentGradient)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final bool isDestructive;
  const _MenuBtn({required this.icon, required this.label, required this.onTap, this.isDestructive = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.accent),
      title: Text(label, style: AppTextStyles.labelLarge.copyWith(color: isDestructive ? AppColors.error : AppColors.textPrimary)),
      onTap: onTap,
    );
  }
}
