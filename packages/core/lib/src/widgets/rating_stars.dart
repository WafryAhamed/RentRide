import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Interactive star rating widget.
class RatingStars extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 24,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starValue = index + 1.0;
        final isFilled = starValue <= rating;
        final isHalf = !isFilled && starValue - 0.5 <= rating;

        return GestureDetector(
          onTap: interactive ? () => onRatingChanged?.call(starValue) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              isFilled
                  ? Icons.star_rounded
                  : isHalf
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
              color: isFilled || isHalf ? AppColors.starFilled : AppColors.starEmpty,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
