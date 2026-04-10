import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class RateDriverScreen extends StatefulWidget {
  const RateDriverScreen({super.key});
  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  double _rating = 5;
  final _commentController = TextEditingController();
  final List<String> _quickTags = ['Great driving', 'Friendly', 'Clean car', 'On time', 'Knows routes', 'Safe'];
  final Set<String> _selectedTags = {'Great driving', 'On time'};
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your feedback! ⭐')));
      context.go('/home');
    }
  }

  @override
  void dispose() { _commentController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.go('/home'), icon: const Icon(Icons.close, size: 22)),
        title: const Text('Rate Your Ride'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Driver avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: const Icon(Icons.person, color: AppColors.primary, size: 44),
            ),
            const SizedBox(height: 12),
            Text('Kamal Silva', style: AppTextStyles.heading3),
            Text('Toyota Prius', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 32),

            Text('How was your ride?', style: AppTextStyles.heading4),
            const SizedBox(height: 16),

            // Star rating
            RatingStars(
              rating: _rating,
              size: 44,
              interactive: true,
              onRatingChanged: (r) => setState(() => _rating = r),
            ),
            const SizedBox(height: 8),
            Text(
              _rating >= 5 ? 'Excellent! ⭐' : _rating >= 4 ? 'Great 😊' : _rating >= 3 ? 'Good 👍' : 'Could be better 🤔',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
            ),
            const SizedBox(height: 32),

            // Quick tags
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _quickTags.map((tag) {
                final selected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() => selected ? _selectedTags.remove(tag) : _selectedTags.add(tag)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withOpacity(0.15) : AppColors.darkCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.darkBorder),
                    ),
                    child: Text(tag, style: TextStyle(fontSize: 13, color: selected ? AppColors.primary : AppColors.textSecondary, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Comment
            RentRideTextField(
              hint: 'Add a comment (optional)...',
              controller: _commentController,
              maxLines: 3,
              prefixIcon: Icons.comment,
            ),
            const SizedBox(height: 32),

            RentRideButton(text: 'Submit Rating', onPressed: _submit, isLoading: _isLoading, icon: Icons.send),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/home'),
              child: Text('Skip', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
    );
  }
}
