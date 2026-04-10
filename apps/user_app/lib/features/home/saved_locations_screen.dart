import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedLocationsScreen extends ConsumerWidget {
  const SavedLocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app we'd fetch this from a provider, using mock data for Phase 1
    final locations = [
      {'title': 'Home', 'address': 'No 45, Galle Road, Colombo 03', 'icon': Icons.home},
      {'title': 'Work', 'address': 'World Trade Center, Echelon Square', 'icon': Icons.work},
      {'title': 'Gym', 'address': 'Fitness First, R.A. De Mel Mawatha', 'icon': Icons.fitness_center},
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('Saved Locations', style: AppTextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              // Push to map picker to add a new location
              context.push('/location-picker');
            },
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: locations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final loc = locations[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(loc['icon'] as IconData, color: AppColors.primary),
              ),
              title: Text(loc['title'] as String, style: AppTextStyles.labelLarge),
              subtitle: Text(
                loc['address'] as String,
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
                color: AppColors.darkSurface,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit', style: AppTextStyles.bodyMedium),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
                  ),
                ],
              ),
              onTap: () {
                // If picking a location
                context.pop(loc['address']);
              },
            ),
          );
        },
      ),
    );
  }
}
