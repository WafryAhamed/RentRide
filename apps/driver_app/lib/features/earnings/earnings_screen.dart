import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('Earnings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total earnings card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text('This Week', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text('Rs. 18,450', style: AppTextStyles.heading1.copyWith(color: Colors.black87, fontSize: 36)),
                  const SizedBox(height: 4),
                  Text('15 trips completed', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Weekly chart
            Text('Weekly Overview', style: AppTextStyles.heading4),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5000,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(days[value.toInt()], style: AppTextStyles.caption);
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    _bar(0, 2400), _bar(1, 3200), _bar(2, 2800), _bar(3, 3600),
                    _bar(4, 2200), _bar(5, 4100), _bar(6, 1500),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            Row(children: [
              _StatCard(icon: Icons.trending_up, label: 'Avg / Trip', value: 'Rs. 1,230', color: AppColors.success),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.access_time, label: 'Online Time', value: '28h 30m', color: AppColors.primary),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _StatCard(icon: Icons.route, label: 'Total Distance', value: '142 km', color: AppColors.accent),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.star, label: 'Rating', value: '4.9 ⭐', color: AppColors.starFilled),
            ]),
            const SizedBox(height: 24),

            // Recent trips
            Text('Recent Trips', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            _TripEarning(from: 'Galle Road', to: 'WTC', fare: 'Rs. 588', time: '8:30 AM'),
            _TripEarning(from: 'Bambalapitiya', to: 'Nugegoda', fare: 'Rs. 780', time: '10:15 AM'),
            _TripEarning(from: 'Colombo Fort', to: 'Dehiwala', fare: 'Rs. 1,082', time: '1:30 PM'),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y, color: AppColors.accent, width: 16, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.darkBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.heading4),
          Text(label, style: AppTextStyles.caption),
        ]),
      ),
    );
  }
}

class _TripEarning extends StatelessWidget {
  final String from; final String to; final String fare; final String time;
  const _TripEarning({required this.from, required this.to, required this.fare, required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$from → $to', style: AppTextStyles.labelLarge),
          Text(time, style: AppTextStyles.caption),
        ]),
        const Spacer(),
        Text(fare, style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
      ]),
    );
  }
}
