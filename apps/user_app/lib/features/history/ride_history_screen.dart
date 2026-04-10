import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});
  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  List<RideModel>? _rides;

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    final rides = await MockRideService.getRideHistory();
    if (mounted) setState(() => _rides = rides);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(title: const Text('Ride History')),
      body: _rides == null
          ? const Center(child: LoadingShimmer(count: 4, height: 120))
          : _rides!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🛺', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text('No rides yet', style: AppTextStyles.heading3),
                      const SizedBox(height: 8),
                      Text('Your ride history will appear here', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRides,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _rides!.length,
                    itemBuilder: (context, i) {
                      return RideCard(
                        ride: _rides![i],
                        onTap: () => context.push('/ride-detail'),
                      );
                    },
                  ),
                ),
    );
  }
}
