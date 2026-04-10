import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class GuideHomeScreen extends StatefulWidget {
  const GuideHomeScreen({super.key});
  @override
  State<GuideHomeScreen> createState() => _GuideHomeScreenState();
}

class _GuideHomeScreenState extends State<GuideHomeScreen> {
  GuideCategory? _selectedCategory;
  List<TravelGuideModel>? _guides;
  List<TravelGuideModel>? _nearby;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final all = await MockGuideService.getAllGuides();
    final nearby = await MockGuideService.getNearbyPlaces(maxDistanceKm: 5);
    if (mounted) setState(() { _guides = all; _nearby = nearby; });
  }

  List<TravelGuideModel> get _filteredGuides {
    if (_guides == null) return [];
    if (_selectedCategory == null) return _guides!;
    return _guides!.where((g) => g.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.darkBg,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Travel Guide', style: AppTextStyles.heading4),
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🌍', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      Text('Explore Sri Lanka', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Category filters
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _CategoryChip(label: 'All', emoji: '🗺️', isSelected: _selectedCategory == null, onTap: () => setState(() => _selectedCategory = null)),
                  ...GuideCategory.values.map((cat) {
                    final guide = TravelGuideModel(id: '', title: '', description: '', category: cat, latitude: 0, longitude: 0, address: '');
                    return _CategoryChip(
                      label: guide.categoryLabel, emoji: guide.categoryIcon,
                      isSelected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Nearby section
          if (_selectedCategory == null && _nearby != null && _nearby!.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Nearby Places', style: AppTextStyles.heading4),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _nearby!.length,
                  itemBuilder: (context, i) {
                    final g = _nearby![i];
                    return _NearbyCard(guide: g, onTap: () => context.push('/place-detail', extra: g.id));
                  },
                ),
              ),
            ),
          ],

          // All guides
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(_selectedCategory == null ? 'All Places' : _filteredGuides.firstOrNull?.categoryLabel ?? '', style: AppTextStyles.heading4),
            ),
          ),

          _guides == null
              ? SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: LoadingShimmer(count: 3, height: 100)))
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final g = _filteredGuides[i];
                      return _GuideListTile(guide: g, onTap: () => context.push('/place-detail', extra: g.id));
                    },
                    childCount: _filteredGuides.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label; final String emoji; final bool isSelected; final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.emoji, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.darkBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _NearbyCard extends StatelessWidget {
  final TravelGuideModel guide; final VoidCallback onTap;
  const _NearbyCard({required this.guide, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.surfaceGradient,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(child: Text(guide.categoryIcon, style: const TextStyle(fontSize: 40))),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guide.title, style: AppTextStyles.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star, size: 14, color: AppColors.starFilled),
                    const SizedBox(width: 4),
                    Text('${guide.rating}', style: AppTextStyles.caption),
                    const Spacer(),
                    Text(Formatters.distance(guide.distanceKm ?? 0), style: AppTextStyles.caption),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideListTile extends StatelessWidget {
  final TravelGuideModel guide; final VoidCallback onTap;
  const _GuideListTile({required this.guide, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkCard, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                gradient: AppColors.surfaceGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(guide.categoryIcon, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guide.title, style: AppTextStyles.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(guide.address, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: AppColors.starFilled),
                    const SizedBox(width: 2),
                    Text('${guide.rating}', style: AppTextStyles.caption),
                    const SizedBox(width: 8),
                    if (guide.priceRange != null) Text(guide.priceRange!, style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                    const Spacer(),
                    if (guide.distanceKm != null) Text(Formatters.distance(guide.distanceKm!), style: AppTextStyles.caption),
                  ]),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
