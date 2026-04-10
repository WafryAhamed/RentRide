import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DriverRatingsScreen extends StatelessWidget {
  const DriverRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
        title: const Text('My Ratings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Overall rating
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.surfaceGradient,
                borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(children: [
                Text('4.9', style: AppTextStyles.heading1.copyWith(fontSize: 48, color: AppColors.accent)),
                const RatingStars(rating: 4.9, size: 32),
                const SizedBox(height: 8),
                Text('Based on 1,250 rides', style: AppTextStyles.bodyMedium),
              ]),
            ),
            const SizedBox(height: 24),

            // Rating breakdown
            Text('Rating Breakdown', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            _RatingBar(stars: 5, percent: 0.85, count: 1063),
            _RatingBar(stars: 4, percent: 0.10, count: 125),
            _RatingBar(stars: 3, percent: 0.03, count: 38),
            _RatingBar(stars: 2, percent: 0.01, count: 12),
            _RatingBar(stars: 1, percent: 0.01, count: 12),
            const SizedBox(height: 24),

            // Recent reviews
            Text('Recent Feedback', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            _Review(name: 'Sahan P.', rating: 5, comment: 'Great driver! Very friendly and knows the routes well.', time: '2h ago'),
            _Review(name: 'Dilini K.', rating: 5, comment: 'Clean car, safe driving. Would recommend!', time: '1d ago'),
            _Review(name: 'Amal J.', rating: 4, comment: 'Good service, arrived on time.', time: '3d ago'),
          ],
        ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int stars; final double percent; final int count;
  const _RatingBar({required this.stars, required this.percent, required this.count});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        SizedBox(width: 20, child: Text('$stars', style: AppTextStyles.labelMedium, textAlign: TextAlign.center)),
        const SizedBox(width: 4),
        const Icon(Icons.star, size: 14, color: AppColors.starFilled),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: percent, backgroundColor: AppColors.darkCard, valueColor: const AlwaysStoppedAnimation(AppColors.accent), minHeight: 8),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 40, child: Text('$count', style: AppTextStyles.caption, textAlign: TextAlign.end)),
      ]),
    );
  }
}

class _Review extends StatelessWidget {
  final String name; final double rating; final String comment; final String time;
  const _Review({required this.name, required this.rating, required this.comment, required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.darkBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.primary.withOpacity(0.2), child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
          const SizedBox(width: 10),
          Text(name, style: AppTextStyles.labelLarge),
          const Spacer(),
          Text(time, style: AppTextStyles.caption),
        ]),
        const SizedBox(height: 8),
        RatingStars(rating: rating, size: 16),
        const SizedBox(height: 8),
        Text(comment, style: AppTextStyles.bodyMedium),
      ]),
    );
  }
}
