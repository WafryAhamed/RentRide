import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});
  @override
  State<SearchDestinationScreen> createState() => _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  final _searchController = TextEditingController();
  final List<Map<String, String>> _recentPlaces = [
    {'name': 'World Trade Center', 'address': 'Echelon Square, Colombo 01', 'icon': '🏢'},
    {'name': 'Bambalapitiya Junction', 'address': 'Galle Road, Colombo 04', 'icon': '🚏'},
    {'name': 'Fort Railway Station', 'address': 'Olcott Mawatha, Colombo 11', 'icon': '🚆'},
    {'name': 'Kandy City Centre', 'address': 'Dalada Veediya, Kandy', 'icon': '🏙️'},
    {'name': 'Bandaranaike Airport', 'address': 'Canada Friendship Rd, Katunayake', 'icon': '✈️'},
  ];

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                border: Border(bottom: BorderSide(color: AppColors.darkBorder)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
                      const SizedBox(width: 4),
                      Text('Where to?', style: AppTextStyles.heading3),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Pickup
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.mapPickup, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Text('23, Galle Road, Colombo 03', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Dropoff search
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.mapDropoff, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController, autofocus: true,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'Enter destination', border: InputBorder.none,
                              enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                            ),
                            onChanged: (v) => setState(() {}),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                            onPressed: () { _searchController.clear(); setState(() {}); },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Saved locations
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _SavedChip(icon: Icons.home, label: 'Home', onTap: () => context.push('/vehicle-selection')),
                  const SizedBox(width: 10),
                  _SavedChip(icon: Icons.work, label: 'Work', onTap: () => context.push('/vehicle-selection')),
                  const SizedBox(width: 10),
                  _SavedChip(icon: Icons.add, label: 'Add', onTap: () {}),
                ],
              ),
            ),

            // Recent places
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Recent Places', style: AppTextStyles.labelLarge),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _recentPlaces.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final place = _recentPlaces[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
                      child: Center(child: Text(place['icon']!, style: const TextStyle(fontSize: 20))),
                    ),
                    title: Text(place['name']!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    subtitle: Text(place['address']!, style: AppTextStyles.caption),
                    trailing: const Icon(Icons.north_west, size: 16, color: AppColors.textMuted),
                    onTap: () => context.push('/vehicle-selection'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedChip extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _SavedChip({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.darkCard, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon, size: 16, color: AppColors.primary), const SizedBox(width: 6), Text(label, style: AppTextStyles.labelMedium)],
        ),
      ),
    );
  }
}
