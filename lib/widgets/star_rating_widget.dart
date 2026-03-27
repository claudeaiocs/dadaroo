import 'package:flutter/material.dart';
import 'package:dadaroo/theme/app_theme.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final ValueChanged<double>? onChanged;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.size = 36,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        return GestureDetector(
          onTap: onChanged != null ? () => onChanged!(starValue) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              rating >= starValue
                  ? Icons.star_rounded
                  : rating >= starValue - 0.5
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
              color: AppTheme.starGold,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
