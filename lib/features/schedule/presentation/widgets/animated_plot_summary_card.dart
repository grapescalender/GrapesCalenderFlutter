import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/schedule_entity.dart';

class AnimatedPlotSummaryCard extends StatelessWidget {
  const AnimatedPlotSummaryCard({
    required this.plotSelector,
    required this.plotName,
    required this.dayAfterPruning,
    required this.scheduleType,
    required this.stageName,
    required this.productCount,
    required this.pruningDate,
    super.key,
  });

  final Widget plotSelector;
  final String plotName;
  final int? dayAfterPruning;
  final ScheduleType scheduleType;
  final String stageName;
  final int productCount;
  final DateTime? pruningDate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasProducts = scheduleType == ScheduleType.spray ||
        scheduleType == ScheduleType.nutrition;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey(
          '$plotName-$scheduleType-$stageName-$productCount-$dayAfterPruning',
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(colors.primary, Colors.black, 0.06) ?? colors.primary,
              colors.primary,
              Color.lerp(colors.secondary, Colors.white, 0.08) ??
                  colors.secondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.22),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Stack(
            children: [
              Positioned(
                left: -54,
                top: -66,
                child: Container(
                  width: 142,
                  height: 142,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.09),
                  ),
                ),
              ),
              Positioned(
                right: -48,
                bottom: -62,
                child: Container(
                  width: 146,
                  height: 146,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.smMd),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    plotSelector,
                    const SizedBox(height: AppSpacing.smMd),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _HeroPill(
                          label: scheduleType.displayName,
                        ),
                        if (hasProducts)
                          _HeroPill(
                            label:
                                '$productCount Product${productCount == 1 ? '' : 's'}',
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.smMd),
                    Row(
                      children: [
                        Expanded(
                          child: _HeroMetric(
                            value: pruningDate == null
                                ? '—'
                                : DateFormat('dd MMM').format(pruningDate!),
                            label: 'Cutting Date',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: _HeroMetric(
                            value: dayAfterPruning == null
                                ? '—'
                                : _ordinalDay(dayAfterPruning!),
                            label: 'After Pruning',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: _HeroMetric(
                            value: stageName,
                            label: 'Current Activity',
                            compactValue: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _ordinalDay(int value) {
    final suffix = value % 100 >= 11 && value % 100 <= 13
        ? 'th'
        : switch (value % 10) {
            1 => 'st',
            2 => 'nd',
            3 => 'rd',
            _ => 'th',
          };
    return '$value$suffix Day';
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.value,
    required this.label,
    this.compactValue = false,
  });

  final String value;
  final String label;
  final bool compactValue;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.24),
              Colors.white.withValues(alpha: 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: (compactValue
                      ? AppTypography.labelLarge(context)
                      : AppTypography.titleMedium(context))
                  .copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              maxLines: compactValue ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelLarge(context).copyWith(
                color: Colors.white.withValues(alpha: 0.74),
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
