import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

/// Skeleton loader — affiché pendant le chargement initial
class PharmacieSkeletonList extends StatelessWidget {
  const PharmacieSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 160, height: 16),
                _box(width: 56, height: 16),
              ],
            ),
            const SizedBox(height: 8),
            _box(width: 100, height: 12),
            const SizedBox(height: 10),
            _box(width: 80, height: 22, radius: 20),
            const SizedBox(height: 10),
            _box(width: 120, height: 12),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _box(height: 34, radius: 10)),
                const SizedBox(width: 8),
                Expanded(child: _box(height: 34, radius: 10)),
                const SizedBox(width: 8),
                Expanded(child: _box(height: 34, radius: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({
    double? width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.skeletonBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}