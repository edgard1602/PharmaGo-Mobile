import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class DistanceBadge extends StatelessWidget {
  const DistanceBadge({required this.distance, super.key});

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        distance,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.accent,
        ),
      ),
    );
  }
}