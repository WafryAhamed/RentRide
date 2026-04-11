import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String guideId;
  const PlaceDetailScreen({super.key, required this.guideId});
  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  TravelGuideModel? _guide;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final guide = await GuideApiService().getGuideById(widget.guideId);
    if (mounted) setState(() => _guide = guide);
  }

  @override
  Widget build(BuildContext context) {
    if (_guide == null) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: AppBar(leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20))),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final g = _guide!;
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: GlassCard(
              padding: const EdgeInsets.all(8), borderRadius: 12,
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
            ),
            actions: [
              GlassCard(
                padding: const EdgeInsets.all(8), borderRadius: 12,
                child: const Icon(Icons.favorite_border, size: 20, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 8),
              GlassCard(
                padding: const EdgeInsets.all(8), borderRadius: 12,
                child: const Icon(Icons.share, size: 20, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Center(child: Text(g.categoryIcon, style: const TextStyle(fontSize: 80))),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text(g.categoryLabel, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(g.title, style: AppTextStyles.heading2),
                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(child: Text(g.address, style: AppTextStyles.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stats row
                  Row(
                    children: [
                      _StatChip(icon: Icons.star, label: '${g.rating}', color: AppColors.starFilled),
                      const SizedBox(width: 8),
                      _StatChip(icon: Icons.reviews, label: '${g.reviewCount} reviews', color: AppColors.textMuted),
                      if (g.distanceKm != null) ...[
                        const SizedBox(width: 8),
                        _StatChip(icon: Icons.route, label: Formatters.distance(g.distanceKm!), color: AppColors.primary),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text('About', style: AppTextStyles.heading4),
                  const SizedBox(height: 8),
                  Text(g.description, style: AppTextStyles.bodyMedium.copyWith(height: 1.6)),
                  const SizedBox(height: 24),

                  // Info Cards
                  if (g.openingHours != null) _InfoCard(icon: Icons.access_time, title: 'Opening Hours', value: g.openingHours!),
                  if (g.priceRange != null) _InfoCard(icon: Icons.payments, title: 'Price Range', value: g.priceRange!),
                  const SizedBox(height: 20),

                  // Tags
                  if (g.tags.isNotEmpty) ...[
                    Text('Tags', style: AppTextStyles.heading4),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: g.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
                        child: Text('#$tag', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                      )).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Map preview
                  Text('Location', style: AppTextStyles.heading4),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 180,
                      child: MapView(latitude: g.latitude, longitude: g.longitude, zoom: 14, interactive: false),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CTA
                  RentRideButton(
                    text: 'Get a Ride Here',
                    onPressed: () => context.push('/vehicle-selection'),
                    icon: Icons.directions_car,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.darkBorder)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color), const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary)),
      ]),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon; final String title; final String value;
  const _InfoCard({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.labelLarge),
        ]),
      ]),
    );
  }
}
