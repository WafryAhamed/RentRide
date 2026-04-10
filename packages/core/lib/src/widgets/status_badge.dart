import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Status badge pill for ride status.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  factory StatusBadge.completed() => const StatusBadge(label: 'Completed', color: AppColors.success, icon: Icons.check_circle);
  factory StatusBadge.cancelled() => const StatusBadge(label: 'Cancelled', color: AppColors.error, icon: Icons.cancel);
  factory StatusBadge.inProgress() => const StatusBadge(label: 'In Progress', color: AppColors.primary, icon: Icons.directions_car);
  factory StatusBadge.searching() => const StatusBadge(label: 'Searching', color: AppColors.accent, icon: Icons.search);

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: badgeColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
