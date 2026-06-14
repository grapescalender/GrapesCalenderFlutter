import 'package:flutter/material.dart';
import '../../../core/design_system/spacing/app_spacing.dart';
import '../app_shimmer.dart';

/// Configurable shimmer skeleton for lists, cards, and custom layouts.
class AppLoadingState extends StatelessWidget {
  final AppLoadingVariant variant;
  final int itemCount;
  final double itemHeight;
  final double? itemWidth;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Axis direction;
  final List<double>? blockHeights;

  const AppLoadingState({
    super.key,
    this.variant = AppLoadingVariant.list,
    this.itemCount = 5,
    this.itemHeight = 56,
    this.itemWidth,
    this.radius = 16,
    this.padding,
    this.direction = Axis.vertical,
    this.blockHeights,
  });

  /// Horizontal card strip (e.g. plots carousel).
  const AppLoadingState.horizontalCards({
    super.key,
    required double cardWidth,
    required double cardHeight,
    this.itemCount = 3,
    this.padding,
  })  : variant = AppLoadingVariant.horizontalCards,
        itemHeight = cardHeight,
        itemWidth = cardWidth,
        radius = 16,
        direction = Axis.horizontal,
        blockHeights = null;

  /// Vertical list rows (e.g. schedule items).
  const AppLoadingState.listRows({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 56,
    this.padding,
  })  : variant = AppLoadingVariant.list,
        itemWidth = null,
        radius = 16,
        direction = Axis.vertical,
        blockHeights = null;

  /// Stacked blocks (e.g. activity stepper).
  AppLoadingState.blocks({
    super.key,
    required List<double> heights,
    this.padding,
  })  : variant = AppLoadingVariant.custom,
        itemCount = 0,
        itemHeight = 0,
        itemWidth = null,
        radius = 16,
        direction = Axis.vertical,
        blockHeights = heights;

  @override
  Widget build(BuildContext context) {
    final pad = padding ??
        const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal);

    Widget skeleton;

    switch (variant) {
      case AppLoadingVariant.horizontalCards:
        skeleton = SizedBox(
          height: itemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, __) => SizedBox(
              width: itemWidth,
              child: ShimmerBox(height: itemHeight, radius: radius),
            ),
          ),
        );
        break;
      case AppLoadingVariant.list:
        skeleton = Column(
          children: List.generate(
            itemCount,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: i == itemCount - 1 ? 0 : AppSpacing.sm),
              child: ShimmerBox(height: itemHeight, radius: radius),
            ),
          ),
        );
        break;
      case AppLoadingVariant.custom:
        final heights = blockHeights ?? const [64.0, 64.0, 64.0];
        skeleton = Column(
          children: [
            for (var i = 0; i < heights.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              ShimmerBox(height: heights[i], radius: radius),
            ],
          ],
        );
        break;
    }

    return Padding(
      padding: pad,
      child: AppShimmer(child: skeleton),
    );
  }
}

enum AppLoadingVariant {
  list,
  horizontalCards,
  custom,
}
